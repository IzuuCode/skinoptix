import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String userId;
  final String doctorName;
  final DateTime date;
  final String status;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorName,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory Appointment.fromMap(String id, Map<String, dynamic> map) {
    return Appointment(
      id: id,
      userId: map['userId'],
      doctorName: map['doctorName'],
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Listen to appointments for current user
  Stream<List<Appointment>> getAppointments(String userId) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Create new appointment
  Future<void> bookAppointment(BuildContext context) async {
    String selectedDoctor = 'Dr. Isuru ';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Book Appointment"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedDoctor,
                  items: ['Dr. Isuru ', 'Dr. Sahan ', 'Dr. Dhanushi ' , 'Dr. Chameesha ',]
                      .map((doctor) => DropdownMenuItem(
                            value: doctor,
                            child: Text(doctor),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedDoctor = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setStateDialog(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(selectedDate == null
                      ? "Select Date"
                      : "${selectedDate!.toLocal()}".split(' ')[0]),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setStateDialog(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text(selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate != null && selectedTime != null) {
                    final combinedDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    final appointment = Appointment(
                      id: '',
                      userId: currentUser!.uid,
                      doctorName: selectedDoctor,
                      date: combinedDateTime,
                      status: 'Pending',
                    );

                    await FirebaseFirestore.instance
                        .collection('appointments')
                        .add(appointment.toMap());

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Appointment booked")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select date & time")),
                    );
                  }
                },
                child: Text("Book"),
              ),
            ],
          );
        });
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Appointments")),
        body: Center(child: Text("Please log in to view your appointments.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Appointment>>(
          stream: getAppointments(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("Error: ${snapshot.error}");
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final appointments = snapshot.data!;
            if (appointments.isEmpty) {
              return Text("No Appointments yet. Tap + to add one.");
            }

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text("Doctor: ${appt.doctorName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${appt.date.toLocal().toString().split('.').first}"),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text("Status: "),
                            Chip(
                              label: Text(
                                appt.status,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getStatusColor(appt.status),
                            ),
                          ],
                        ),
                      ],
                    ),
                    leading: Icon(Icons.calendar_today, color: Colors.lightBlue),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Appointment with ${appt.doctorName} tapped")),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () => bookAppointment(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
