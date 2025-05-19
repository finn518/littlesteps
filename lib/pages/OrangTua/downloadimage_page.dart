import 'dart:io';
import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImagePage extends StatefulWidget {
  final String url;
  final String date;

  const DownloadImagePage({super.key, required this.url, required this.date});

  @override
  State<DownloadImagePage> createState() => _DownloadImagePageState();
}

class _DownloadImagePageState extends State<DownloadImagePage> {
  // Function to request permissions
  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission is required to download files.'),
      ));
    }
  }

  // Function to download the image
  Future<void> downloadImage(String url, String filename) async {
    try {
      // Request permission to write to storage
      await requestStoragePermission();

      // Get the external storage directory (Downloads folder)
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      String? downloadsPath = downloadsDirectory?.path;

      if (downloadsPath != null) {
        // Save the file in the "Download" folder
        String savePath = '$downloadsPath/Download/$filename';

        // Ensure that the "Download" folder exists
        final downloadFolder = Directory('$downloadsPath/Download');
        if (!await downloadFolder.exists()) {
          await downloadFolder.create(recursive: true);
        }

        // Download the image using Dio
        var dio = Dio();
        await dio.download(url, savePath);

        // Show a Snackbar or dialog to inform the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image saved to $savePath'),
        ));
      }
    } catch (e) {
      print('Error downloading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to download image'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 36,
            )),
        title: Text(
          widget.date,
          style: TextStyle(
              fontVariations: [FontVariation('wght', 800)], fontSize: 28),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                // Call the download function when button is pressed
                downloadImage(widget.url, 'image_${widget.date}.jpg');
              },
              icon: ImageIcon(AssetImage('assets/icons/download.png')),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.01),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(widget.url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
