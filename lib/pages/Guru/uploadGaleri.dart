import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadGaleri extends StatefulWidget {
  const UploadGaleri({super.key});

  @override
  State<UploadGaleri> createState() => _UploadGaleriState();
}

class _UploadGaleriState extends State<UploadGaleri> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;

  Future<void> handleUpload(String label) async {
    XFile? file;

    if (label == "Foto") {
      file = await _picker.pickImage(source: ImageSource.gallery);
    } else if (label == "Kamera") {
      file = await _picker.pickImage(source: ImageSource.camera);
    } else if (label == "Video") {
      file = await _picker.pickVideo(source: ImageSource.gallery);
    }

    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
  }

  Widget _uploadButton(String label, String imagePath,
      {bool selected = false}) {
    Color labelColor;
    switch (label) {
      case 'Foto':
        labelColor = Color(0xFF53B1FD);
        break;
      case 'Kamera':
        labelColor = Color(0xFFFBBC05);
        break;
      case 'Video':
        labelColor = Color(0xFFFF9C66);
        break;
      default:
        labelColor = Colors.black;
    }

    return GestureDetector(
      onTap: () => handleUpload(label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.orange[100] : Colors.white,
          border: Border.all(color: selected ? Colors.orange : Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 32, width: 32),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upload",
          style: TextStyle(
              color: Colors.black,
              fontVariations: [FontVariation('wght', 800)],
              fontSize: 26),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tulis catatan Anda disini...",
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _selectedFile != null
                    ? (_selectedFile!.path.endsWith('.mp4')
                        ? Container(
                            height: 225,
                            width: double.infinity,
                            color: Colors.black12,
                            child: Center(
                              child: Icon(Icons.videocam,
                                  size: 64, color: Colors.grey),
                            ),
                          )
                        : Image.file(
                            File(_selectedFile!.path),
                            height: 225,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ))
                    : Image.asset(
                        'assets/images/GAMBAR_UPLOAD_JANUARI.png',
                        height: 225,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _uploadButton(
                          "Foto", "assets/icons/upload_foto.png")),
                  SizedBox(width: 12),
                  Expanded(
                      child: _uploadButton(
                          "Kamera", "assets/icons/upload_kamera.png")),
                  SizedBox(width: 12),
                  Expanded(
                      child: _uploadButton(
                          "Video", "assets/icons/upload_video.png")),
                ],
              ),
              SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Unggah",
                    style: TextStyle(
                        fontVariations: [FontVariation('wght', 800)],
                        fontSize: 16,
                        color: Colors.white),
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
