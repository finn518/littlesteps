import "package:flutter/material.dart";

class InformasiAnakPage extends StatelessWidget {
  const InformasiAnakPage({super.key});

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
              backgroundImage: AssetImage('assets/images/siti.png'),
            ),
            SizedBox(height: 16),
            Text(
              "Siti Fatimah",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 36),
            buildMenuButton("Catatan Kesehatan", Color(0xffB2DDFF)),
            buildMenuButton("Laporan Perkembangan", Color(0xffFDE272)),
            buildMenuButton("Rangkuman Penilaian", Color(0xffFF9C66)),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(String label, Color? color) {
    return Container(
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
    );
  }

}