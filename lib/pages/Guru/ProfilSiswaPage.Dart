import 'dart:io';
import 'package:flutter/material.dart';
import 'KelasPage.dart';
import 'siswa.dart';

class ProfilSiswaPage extends StatelessWidget {
  final Siswa siswa;

  const ProfilSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Color(0xff53B1FD), Colors.white, 0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            CircleAvatar(radius: 50, backgroundImage: siswa.imagePath.startsWith('assets') ? AssetImage(siswa.imagePath) as ImageProvider : FileImage(File(siswa.imagePath)),
            ),
            const SizedBox(height: 16),
            Text(siswa.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            buildMenuButton(context, "Catatan Kesehatan", Color(0xFFB5D9F8)),
            buildMenuButton(context, "Laporan Perkembangan", Color(0xFFFDE272)),
            buildMenuButton(context, "Rangkuman Penilaian", Color(0xFFFFAD8C)),
            buildMenuButton(context, "Rangkuman Kehadiran", Color(0xFF8ED68D)),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(BuildContext context, String title, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          onPressed: (){
            //TODO
          },
          child: Text(title, style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold,
            fontSize: 16,
          ))
        )
      )
    );
  }
}
