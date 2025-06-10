import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

late List<CameraDescription> cameras;

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  dynamic controller;
  bool isBusy = false;
  dynamic objectDetector;
  late Size size;
  dynamic _scanResults;
  CameraImage? img;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    cameras = await availableCameras();
    const mode = DetectionMode.stream;
    final modelPath = await _getModel('assets/ml/mobilenet.tflite');
    final options = LocalObjectDetectorOptions(
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
      mode: mode,
    );
    objectDetector = ObjectDetector(options: options);

    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          img = image;
          doObjectDetectionOnFrame();
        }
      });
    });
  }

  Future<String> _getModel(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  doObjectDetectionOnFrame() async {
    var frameImg = getInputImage();
    List<DetectedObject> objects = await objectDetector.processImage(frameImg);
    setState(() {
      _scanResults = objects;
    });
    isBusy = false;
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? getInputImage() {
    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(img!.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (img!.planes.length != 1) return null;
    final plane = img!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Widget buildResult() {
    if (_scanResults == null || controller == null || !controller.value.isInitialized) {
      return const Text('');
    }
    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter = ObjectDetectorPainter(imageSize, _scanResults);
    return CustomPaint(painter: painter);
  }

  @override
  void dispose() {
    controller?.dispose();
    objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: (controller.value.isInitialized)
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                )
              : Container(),
        ),
      );
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Object Detector"),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.black,
        child: Stack(children: stackChildren),
      ),
    );
  }
}

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this.absoluteImageSize, this.objects);

  final Size absoluteImageSize;
  final List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pinkAccent;

    for (DetectedObject detectedObject in objects) {
      canvas.drawRect(
        Rect.fromLTRB(
          detectedObject.boundingBox.left * scaleX,
          detectedObject.boundingBox.top * scaleY,
          detectedObject.boundingBox.right * scaleX,
          detectedObject.boundingBox.bottom * scaleY,
        ),
        paint,
      );
      var list = detectedObject.labels;
      for (Label label in list) {
        TextSpan span = TextSpan(
            text: label.text,
            style: const TextStyle(fontSize: 25, color: Colors.blue));
        TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            canvas,
            Offset(detectedObject.boundingBox.left * scaleX,
                detectedObject.boundingBox.top * scaleY));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(ObjectDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.objects != objects;
  }
}
