//Belum Terdaftar -> Login Page
//Sudah Terdaftar -> Home Page

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/pages/login_page.dart';
import 'package:littlesteps/utils/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthGate extends StatelessWidget {
  final String role;
  const AuthGate({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://littlesteps-52095-default-rtdb.asia-southeast1.firebasedatabase.app/').ref();

    return StreamBuilder<User?>(
      stream: AuthService().authStateChange,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final user = authSnapshot.data;
        if (user != null) {
          return StreamBuilder<DatabaseEvent>(
            stream: databaseRef.child('users/${user.uid}').onValue,
            builder: (context, dbSnapshot) {
              if (dbSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              if (!dbSnapshot.hasData ||
                  dbSnapshot.data!.snapshot.value == null) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  databaseRef.child('users/${user.uid}').keepSynced(true);
                });
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              final userData = Map<String, dynamic>.from(
                  dbSnapshot.data!.snapshot.value as Map<dynamic, dynamic>);
              final userRole = userData['role'] as String? ?? '';

              switch (userRole) {
                case "Guru":
                  return const HomepageGuru();
                case "Orang Tua":
                  return const HomePageOrangTua();
                default:
                  return const Scaffold(
                      body: Center(child: Text("Role tidak dikenali")));
              }
            },
          );
        } else {
          return LoginPage(role: role);
        }
      },
    );
  }
}
