import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? gender;

  TextEditingController medicalConditionsController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController surgeriesController = TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          nameController.text = snapshot['name'] ?? '';
          addressController.text = snapshot['address'] ?? '';
          mobileController.text = snapshot['mobile'] ?? '';
          ageController.text = snapshot['age']?.toString() ?? '';
          gender = snapshot['gender'] ?? '';
          medicalConditionsController.text =
              snapshot['medicalConditions'] ?? '';
          allergiesController.text = snapshot['allergies'] ?? '';
          surgeriesController.text = snapshot['surgeries'] ?? '';
        });
      }
    }
  }

  void saveProfile() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).set({
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'mobile': mobileController.text.trim(),
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': gender,
        'medicalConditions': medicalConditionsController.text.trim(),
        'allergies': allergiesController.text.trim(),
        'surgeries': surgeriesController.text.trim(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile Updated")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // -- REMOVED PROFILE PICTURE PART HERE --

            // Basic Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: "Age",
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: "Male",
                          child: Text("Male"),
                        ),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child: Text("Other"),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: "Gender",
                        prefixIcon:
                            Icon(Icons.transgender, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: mobileController,
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        prefixIcon: Icon(Icons.phone, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.home, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Medical Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Medical Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: medicalConditionsController,
                      decoration: InputDecoration(
                        labelText: "Past and Current Medical Conditions",
                        prefixIcon: Icon(Icons.medical_services,
                            color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: allergiesController,
                      decoration: InputDecoration(
                        labelText: "Allergies",
                        prefixIcon:
                            Icon(Icons.warning, color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: surgeriesController,
                      decoration: InputDecoration(
                        labelText: "Previous Surgeries or Treatments",
                        prefixIcon: Icon(Icons.medical_information,
                            color: Colors.lightBlue),
                        filled: true,
                        fillColor: Colors.lightBlue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveProfile,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
