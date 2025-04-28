import 'package:flutter/material.dart';
import "package:littlesteps/utils/auth.dart";

import 'KelasPage.dart';
import 'calenderPage.dart';
import 'kehadiranPage.dart';
import 'koneksiSiswaPage.dart';
import 'siswa.dart';

class HomepageGuru extends StatefulWidget {
  const HomepageGuru({super.key});

  @override
  State<HomepageGuru> createState() => _nameState();
}

class _nameState extends State<HomepageGuru> {
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.lerp(Color(0xff53B1FD), Colors.white, 0.9),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _menuButton(Icons.calendar_month, 'Calender',
                              Color(0xFF8ED8FA), CalenderPage())),
                      Expanded(
                          child: _menuButton(Icons.person, 'Kehadiran',
                              Color(0xFFFDE272), KehadiranPage())),
                      Expanded(
                          child: _menuButton(Icons.book, 'Koneksi Siswa',
                              Color(0xFFFF9C66), koneksiSiswaPage())),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                      child: ListView(
                    children: [
                      _classCard(
                          'Kelas A',
                          'assets/kelas_a.png',
                          Colors.blue[100]!,
                          KelasPage(
                              namaKelas: 'Kelas A', listSiswa: siswaKelasA)),
                      _classCard(
                          'Kelas B',
                          'assets/kelas_b.png',
                          Colors.yellow[100]!,
                          KelasPage(
                              namaKelas: 'Kelas B', listSiswa: siswaKelasB)),
                    ],
                  ))
                ],
              )),
        ));
  }
}

Widget _menuButton(IconData icon, String label, Color color, Widget halaman) {
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
                Icon(icon, color: Colors.black, size: 28),
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
