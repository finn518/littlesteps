import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/uploadGaleri.dart';
import 'package:littlesteps/widgets/postcard.dart';

class GaleriGuruPage extends StatelessWidget {
  const GaleriGuruPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _monthTab("Januari",
                          "assets/images/GAMBAR_UPLOAD_JANUARI.png", false),
                      SizedBox(width: 8),
                      _monthTab("Februari",
                          "assets/images/GAMBAR_UPLOAD_FEBRUARI.png", true),
                      SizedBox(width: 8),
                      _monthTab("Maret", null, false),
                      SizedBox(width: 8),
                      _monthTab("April", null, false),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                  child: ListView(
                children: [PostCard(), PostCard()],
              ))
            ],
          ),
        ),
        Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF4285F4),
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadGaleri()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ))
      ],
    );
  }

  Widget _monthTab(String label, String? iconPath, bool isSelected) {
    final String imagePath = iconPath ?? "assets/icons/Galeri_bulan.png";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.image_not_supported, size: 60),
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
