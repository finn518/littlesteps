import "package:flutter/material.dart";
import "package:littlesteps/utils/auth.dart";


class HomePageOrangTua extends StatefulWidget {
  const HomePageOrangTua({super.key});

  @override
  State<HomePageOrangTua> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageOrangTua> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Halo dari Orang Tua"),
          OutlinedButton(onPressed: logout, child: Text("Keluar"))
        ],
      ))),
    );
  }
}