import 'package:flutter/material.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen({super.key});

  @override
  _MedicalReportScreenState createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  final TextEditingController _inputController = TextEditingController();
  String reply = "Please enter your query to get a reply.";

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _inputController.dispose();
    super.dispose();
  }

  // Placeholder method to simulate fetching a reply from a database
  void _fetchReplyFromDatabase(String userInput) {
    setState(() {
      // Simulate fetching a reply from a database
      reply = "Reply from Admin: Your Message \"$userInput\" has been received.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Support"),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Replace with your local image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Enter your Message:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: "Enter your question",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String userInput = _inputController.text;
                  if (userInput.isNotEmpty) {
                    _fetchReplyFromDatabase(userInput); // Fetch reply based on input
                  } else {
                    setState(() {
                      reply = "Please enter a query to get a reply.";
                    });
                  }
                },
                child: Text("Submit"),
              ),
              const SizedBox(height: 30),
              Text(
                "Reply:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                reply,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
