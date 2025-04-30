import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class CatatankesehatanPage extends StatelessWidget {
  const CatatankesehatanPage({super.key});

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
          SizedBox(height: 40),
          CardCatatan(
            number: 1,
            body: content(),
            title: "Semester 1",
          ),
          SizedBox(height: 15),
          CardCatatan(
            number: 2,
            body: content(),
            title: "Semester 2",
          ),
          SizedBox(height: 15),
          CardCatatan(
            number: 3,
            body: content(),
            title: "Semester 3",
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lingkaran Kepala :", style: TextStyle(fontSize: 14)),
          SizedBox(height: 4),
          Text("Tinggi Badan :", style: TextStyle(fontSize: 14)),
          SizedBox(height: 4),
          Text("Berat Badan :", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
