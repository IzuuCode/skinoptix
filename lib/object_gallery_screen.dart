import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ObjectGalleryScreen extends StatefulWidget {
  const ObjectGalleryScreen({Key? key}) : super(key: key);

  @override
  _ObjectGalleryScreenState createState() => _ObjectGalleryScreenState();
}

class _ObjectGalleryScreenState extends State<ObjectGalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  ui.Image? _uiImage;
  List<dynamic> _predictions = [];

  final String modelId = "acne_v3/9";
  final String apiKey = "YjqSds4nAZaJkl5JDXi0";

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final imageFile = File(picked.path);
      final decodedImage = await decodeImageFromList(await imageFile.readAsBytes());

      setState(() {
        _imageFile = imageFile;
        _uiImage = decodedImage;
        _predictions = [];
      });

      await _detectWithRoboflow(imageFile);
    }
  }

  Future<void> _detectWithRoboflow(File imageFile) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());

    final url = Uri.parse("https://serverless.roboflow.com/$modelId?api_key=$apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: base64Image,
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        _predictions = result['predictions'];
      });
    } else {
      print("Detection error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Roboflow Object Detection"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pick Image from Gallery"),
              ),
            ),
            const SizedBox(height: 20),
            _uiImage != null
                ? Expanded(
                    child: FittedBox(
                      child: SizedBox(
                        width: _uiImage!.width.toDouble(),
                        height: _uiImage!.height.toDouble(),
                        child: CustomPaint(
                          painter: RoboflowPainter(_uiImage!, _predictions),
                        ),
                      ),
                    ),
                  )
                : const Text("No image selected."),
          ],
        ),
      ),
    );
  }
}

class RoboflowPainter extends CustomPainter {
  final ui.Image image;
  final List<dynamic> predictions;

  RoboflowPainter(this.image, this.predictions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, Paint());

    for (var pred in predictions) {
      final left = pred['x'] - pred['width'] / 2;
      final top = pred['y'] - pred['height'] / 2;
      final right = left + pred['width'];
      final bottom = top + pred['height'];

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

      final labelPainter = TextPainter(
        text: TextSpan(
          text: "${pred['class']} ${(pred['confidence'] * 100).toStringAsFixed(1)}%",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            backgroundColor: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      labelPainter.layout();
      labelPainter.paint(canvas, Offset(left, top - 25));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
