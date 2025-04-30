import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailPenilaianPage extends StatelessWidget {
  const DetailPenilaianPage({super.key});

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
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 48),
        children: [
          Center(
            child: Text(
              "Catatan Kesehatan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Nilai Agama dan Moral",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(0xff707070),
              ),
            ),
          ),
          SizedBox(height: 40),
          CardCatatan(
            reverse: true,
            number: 1,
            body: content("Berdoa sebelum dan sesudah melaksanakan kegiatan"),
            title: "Berkembang Sangat Baik",
          ),
          SizedBox(height: 15),
          CardCatatan(
            reverse: true,
            number: 2,
            body: content("Menyanyikan lagu-lagu keagamaan"),
            title: "Berkembang Sangat Baik",
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget content(String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(detail, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center,)
      )
    );
  }
}
