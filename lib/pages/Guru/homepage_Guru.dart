import 'package:flutter/material.dart';
import "package:littlesteps/utils/auth_service.dart";

class HomepageGuru extends StatefulWidget {
  const HomepageGuru({super.key});

  @override
  State<HomepageGuru> createState() => _nameState();
}

class _nameState extends State<HomepageGuru> {
  final authService = AuthService();
  void logout() async{
    await authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Halo dari Guru"),
          OutlinedButton(onPressed: logout, child: Text("Keluar"))
        ],
      ))),
    );
  }
}