import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:skinoptix/home.dart';
import 'package:skinoptix/services/database.dart';
import 'package:skinoptix/services/shared_pref.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false; // Added loading state

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future<void> registration() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });

      // Assign values to mail and password
      String mail = emailcontroller.text.trim();
      String password = passwordcontroller.text.trim();

      try {
        // Create user with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail, password: password);

        if (userCredential.user != null) {
          String id = randomAlphaNumeric(10);

          // Save user details to SharedPreferences
          await SharedpreferenceHelper()
              .saveUserName(namecontroller.text.trim());
          await SharedpreferenceHelper().saveUserEmail(mail);
          await SharedpreferenceHelper().saveUserImage(
              "https://firebasestorage.googleapis.com/v0/b/baber-app-1659e.appspot.com/o/WIN_20230306_20_20_38_Pro.jpg?alt=media&token=2df4296b-3b63-4a3c-a5d7-28b7db543cfa");
          await SharedpreferenceHelper().saveUserId(id);

          // Save user details to Firestore
          Map<String, dynamic> userInfoMap = {
            "Name": namecontroller.text.trim(),
            "Email": mail,
            "Id": id,
            "Image":
                "https://firebasestorage.googleapis.com/v0/b/baber-app-1659e.appspot.com/o/WIN_20230306_20_20_38_Pro.jpg?alt=media&token=2df4296b-3b63-4a3c-a5d7-28b7db543cfa"
          };
          await DatabaseMethods().addUserDetails(userInfoMap, id);

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Registered Successfully",
                  style: TextStyle(fontSize: 20.0),
                ),
                duration: Duration(seconds: 3), // Add duration
              ),
            );
          }

          // Navigate to Home Page
          if (!mounted) return;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreen(email: mail)));
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false; // Stop loading on error
          });

          String errorMessage = "An error occurred. Please try again.";
          if (e.code == 'weak-password') {
            errorMessage = "Password is too weak.";
          } else if (e.code == 'email-already-in-use') {
            errorMessage = "Account already exists.";
          } else if (e.code == 'invalid-email') {
            errorMessage = "Invalid email address.";
          } else if (e.code == 'network-request-failed') {
            errorMessage =
                "Network error. Please check your internet connection.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(errorMessage, style: const TextStyle(fontSize: 20.0)),
              duration: const Duration(seconds: 3), // Add duration
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false; // Stop loading on error
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Error: $e", style: const TextStyle(fontSize: 20.0)),
              duration: const Duration(seconds: 3), // Add duration
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false; // Stop loading in all cases
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 30.0),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                "Hello\nSign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SingleChildScrollView(
      
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      controller: namecontroller,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      controller: passwordcontroller,
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: registration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
