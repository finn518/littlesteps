import "package:flutter/material.dart";
import "package:littlesteps/pages/Guru/laporanPerkembanganGuruPage.dart";
import "package:littlesteps/pages/Guru/rangkumanKehadiran.dart";
import 'dart:io';
import "package:littlesteps/pages/Guru/siswa.dart";
import "package:littlesteps/pages/ProfilSiswa/catatankesehatan_page.dart";
import "package:littlesteps/pages/ProfilSiswa/detaillaporanperkembangan_page.dart";
import "package:littlesteps/pages/ProfilSiswa/rangkumanpenilaian_page.dart";

class ProfilSiswaPage extends StatelessWidget {
  final Siswa siswa;
  const ProfilSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 30),
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                Icons.arrow_back,
                size: 36,
                )
            ),
        ),
        body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: siswa.imagePath.startsWith('assets') ? AssetImage(siswa.imagePath) as ImageProvider : FileImage(File(siswa.imagePath)),
            ),
            SizedBox(height: 25),
            Text(
              siswa.name,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 30),
            buildMenuButton("Catatan Kesehatan", Color(0xffB2DDFF), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CatatankesehatanPage()));
            }),
            buildMenuButton("Laporan Perkembangan", Color(0xffFDE272), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => LaporanPerkembanganGuru()));
            }),
            buildMenuButton("Rangkuman Penilaian", Color(0xffFF9C66), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RangkumanPerkembanganPage()));
            }),
            buildMenuButton("Rangkuman Kehadiran", Color(0xffACDC79), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RangkumanKehadiran()));
            }),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(String label, Color? color, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 48),
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

}