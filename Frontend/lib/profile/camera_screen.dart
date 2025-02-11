import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({required this.cameras, super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCameraIndex);
  }

  void _initializeCamera(int cameraIndex) {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final aspectRatio = _controller!.value.aspectRatio;

            // Get the correct rotation angle from the camera controller
            final deviceOrientation = _controller!.description.sensorOrientation;
            final rotationAngle = _getRotationAngle(deviceOrientation);

            return Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: _buildControls(context),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Function to get the rotation angle based on the camera's sensor orientation
  int _getRotationAngle(int deviceOrientation) {
    if (deviceOrientation == 90 || deviceOrientation == 270) {
      return 90; // Rotate 90 degrees if the device is in portrait mode
    }
    return 0; // No rotation required for landscape mode
  }

  Widget _buildControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 45),
            GestureDetector(
              onTap: () async {
                try {
                  final image = await _controller!.takePicture();

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePreviewScreen(imagePath: image.path),
                    ),
                  );

                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.switch_camera, color: Colors.white, size: 30),
              onPressed: () {
                setState(() {
                  _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
                  _initializeCamera(_selectedCameraIndex);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  const ImagePreviewScreen({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Transform.rotate(
              angle: 0.0, // Set the rotation angle to match the preview angle
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                onPressed: () {
                  Navigator.pop(context, imagePath);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
