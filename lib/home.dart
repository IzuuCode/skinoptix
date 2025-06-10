import 'package:flutter/material.dart';
import 'package:skinoptix/object_detection_screen.dart';
import 'login.dart';
import 'drawer/profile.dart';
import 'drawer/appointments.dart';
import 'drawer/live_support.dart';
import 'drawer/online_report.dart';
import 'drawer/upload_image.dart';
import 'package:skinoptix/object_gallery_screen.dart';

class HomeScreen extends StatelessWidget {
  final String email; // User's email passed from login

  const HomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.medical_services,
                        size: 40, color: Colors.lightBlue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.lightBlue),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.calendar_today, color: Colors.lightBlue),
              title: const Text(
                "Appointments",
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.medical_services, color: Colors.lightBlue),
              title: const Text(
                "Live support",
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalReportScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.lightBlue),
              title: const Text(
                "Online Report",
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlineReportScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.lightBlue),
              title: const Text(
                "Upload Image",
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadImageScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, color: Colors.red, size: 24),
              title: const Text(
                "Log out",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.medical_services,
                  size: 100, color: Color.fromARGB(255, 10, 106, 150)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Welcome, $email",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "📸 Instructions for capturing images:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "• Ensure good lighting.\n"
                          "• Keep the camera steady.\n"
                          "• Focus clearly on the subject.\n"
                          "• Avoid shadows.\n"
                          "• Capture high-resolution images.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            height: 1.5, // Better line spacing
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt, size: 24),
                label: const Text("Open Camera"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ObjectDetectionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library, size: 24),
                label: const Text("Open Gallery"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ObjectGalleryScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
