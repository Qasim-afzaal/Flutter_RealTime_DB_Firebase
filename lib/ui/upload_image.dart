import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:real_time_db_firebase/utils/utils.dart';
import 'package:real_time_db_firebase/widgets/round_button.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool isLoading = false;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('Post');

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      } else {
        Utils.showToast('No image selected.');
      }
    } catch (e) {
      Utils.showToast('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      Utils.showToast('Please select an image first.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final ref = _storage.ref('/uploads/${DateTime.now().millisecondsSinceEpoch}');
      final snapshot = await ref.putFile(_selectedImage!).whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _databaseRef.child('1').set({'id': '1212', 'title': downloadUrl});

      Utils.showToast('Image uploaded successfully.');
    } catch (e) {
      Utils.showToast('Error uploading image: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.image)),
              ),
            ),
            const SizedBox(height: 40),
            RoundButton(title: 'Upload', loading: isLoading, onTap: _uploadImage),
          ],
        ),
      ),
    );
  }
}
