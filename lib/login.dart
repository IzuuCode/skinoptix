import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skinoptix/home.dart';
import 'package:skinoptix/signup.dart';
import 'package:skinoptix/reset_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? mail, password;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool isLoading = false; // ADD THIS

  Future<void> userLogin() async {
    setState(() {
      isLoading = true; // Show the loader
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail!, password: password!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful!", style: TextStyle(fontSize: 18.0)),
          backgroundColor: Colors.green,
        ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(email: emailcontroller.text)));
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') {
        message = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: TextStyle(fontSize: 18.0)),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide the loader
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.medical_services,
                      size: 60, color: Colors.lightBlue[700]),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue[900],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),

                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue[800])),
                      SizedBox(height: 5),
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
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.email, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      SizedBox(height: 20),

                      Text("Password",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue[800])),
                      SizedBox(height: 5),
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
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ),
                            );
                          },
                          child: Text("Forgot Password?",
                              style: TextStyle(color: Colors.lightBlue[700])),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Sign In Button or Loader
                      isLoading
                          ? Center(
                              child:
                                  CircularProgressIndicator(color: Colors.blue))
                          : GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    mail = emailcontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                  userLogin();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.lightBlue[800],
                                  fontSize: 16.0)),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup())),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
