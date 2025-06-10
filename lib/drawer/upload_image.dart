import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    File file = File(image.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload image to Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName.jpg');
    UploadTask uploadTask = storageRef.putFile(file);

    await uploadTask.whenComplete(() async {
      String downloadUrl = await storageRef.getDownloadURL();
      
      // Save URL to Firestore
      FirebaseFirestore.instance.collection('images').add({'url': downloadUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _pickAndUploadImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Capture & Upload"),
        ),
      ),
    );
  }
}
