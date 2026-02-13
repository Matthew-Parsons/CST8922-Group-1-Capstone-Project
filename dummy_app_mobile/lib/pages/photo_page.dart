import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  CameraController? _cameraController;
  bool _isCameraOn = false;
  String? _capturedPhotoPath;
  List<CameraDescription>? _cameras;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
      return;
    }

    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras found')),
        );
      }
      return;
    }

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    
    setState(() {
      _isCameraOn = true;
    });
  }

  Future<void> _stopCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _isCameraOn = false;
    });
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedPhotoPath = image.path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Take Photo',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (!_isCameraOn)
            ElevatedButton(
              onPressed: _startCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Start Camera', style: TextStyle(fontSize: 16)),
            )
          else
            Row(
              children: [
                ElevatedButton(
                  onPressed: _stopCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Stop Camera', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _takePhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Capture Photo', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          if (_isCameraOn && _cameraController != null && _cameraController!.value.isInitialized)
            const SizedBox(height: 20),
          if (_isCameraOn && _cameraController != null && _cameraController!.value.isInitialized)
            Container(
              width: 640,
              height: 480,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CameraPreview(_cameraController!),
              ),
            ),
          if (_capturedPhotoPath != null)
            const SizedBox(height: 30),
          if (_capturedPhotoPath != null)
            const Text(
              'Captured Photo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          if (_capturedPhotoPath != null)
            const SizedBox(height: 10),
          if (_capturedPhotoPath != null)
            Container(
              constraints: const BoxConstraints(maxWidth: 640),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(File(_capturedPhotoPath!)),
              ),
            ),
          if (_capturedPhotoPath != null)
            const SizedBox(height: 10),
          if (_capturedPhotoPath != null)
            Text(
              'Saved to: $_capturedPhotoPath',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
