import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/pages/role_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final user = auth.currentUser;

    // Jika user sudah login dan email terverifikasi
    if (user != null && user.emailVerified) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final role = doc['role'];

        if (role == 'Guru') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomepageGuru(role: role)),
          );
          return;
        } else if (role == 'Orang Tua') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePageOrangTua(role: role)),
          );
          return;
        }
      }

      // Jika data role tidak lengkap, fallback ke RolePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RolePage()),
      );
    } else {
      // Jika belum login, tampilkan splash screen selama 3 detik
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RolePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xffD1E9FF),
              Colors.white,
              Colors.white,
              Color(0xBFFEF7C3),
            ],
            stops: [0.0, 0.58, 0.67, 1],
          ),
        ),
        child: Center(
         child: Image.asset(
            'assets/images/LOGO_FINAL.png',
            width: 325, // default size sesuai Native Splash
            height: 325,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
