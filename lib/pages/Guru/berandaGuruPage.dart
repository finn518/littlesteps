import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/KehadiranPage.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/koneksiSiswaPage.dart';
import 'package:littlesteps/pages/Guru/siswa.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';

class BerandaGuru extends StatelessWidget {
  final String role;
  const BerandaGuru({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: _menuButton("assets/icons/guru_kalender.png",
                          'Calender', Color(0xFF8ED8FA), JadwalHarianPage())),
                  Expanded(
                      child: _menuButton("assets/icons/guru_kehadiran.png",
                          'Kehadiran', Color(0xFFFDE272), KehadiranPage())),
                  Expanded(
                      child: _menuButton(
                          "assets/icons/guru_koneksi_siswa.png",
                          'Koneksi Siswa',
                          Color(0xFFFF9C66),
                          koneksiSiswaPage())),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                  child: ListView(
                children: [
                  _classCard(
                      'Kelas A',
                      'assets/images/Kelas_A.png',
                      Colors.blue[100]!,
                      KelasPage(
                          namaKelas: 'Kelas A',
                          listSiswa: siswaKelasA,
                          role: role)),
                  _classCard(
                      'Kelas B',
                      'assets/images/Kelas_B.png',
                      Colors.yellow[100]!,
                      KelasPage(
                          namaKelas: 'Kelas B',
                          listSiswa: siswaKelasB,
                          role: role)),
                ],
              ))
            ],
          )),
    );
  }

  Widget _menuButton(
      String imagePath, String label, Color color, Widget halaman) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => halaman),
            );
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: Offset(0, 5))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    height: 28,
                    width: 28,
                  ),
                  SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  Widget _classCard(
      String name, String imagePath, Color bgColor, Widget halaman) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => halaman),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150, // bisa disesuaikan
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
