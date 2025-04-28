import 'package:flutter/material.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text("Jadwal Harian", style: TextStyle(color: Colors.black)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xff84CAFF),
              Colors.white,
              Colors.white,
              Color(0xffFDE272),
            ],
            stops: [0.0, 0.58, 0.67, 1],
          ),
        ),
        child: Center(
          child: Text(
            "KALENDER DAN REMINDER",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
