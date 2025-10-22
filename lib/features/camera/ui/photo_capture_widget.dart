// Simple Photo Capture Widget for Building Photos
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PhotoCaptureWidget extends StatefulWidget {
  final Function(String) onPhotoTaken;

  const PhotoCaptureWidget({
    super.key,
    required this.onPhotoTaken,
  });

  @override
  State<PhotoCaptureWidget> createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Building Photo'),
      ),
      body: Center(
        child: _isUploading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Uploading photo...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Take a photo of the building or location',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _capturePhoto(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _capturePhoto(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _capturePhoto(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() => _isUploading = true);

        // Upload to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('building_photos')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = storageRef.putFile(File(photo.path));
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        widget.onPhotoTaken(downloadUrl);

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() => _isUploading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading photo: $e')),
        );
      }
    }
  }
}
