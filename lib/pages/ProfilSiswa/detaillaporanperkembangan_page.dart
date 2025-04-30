import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailLaporanPerkembanganPage extends StatelessWidget {
  const DetailLaporanPerkembanganPage({super.key});

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
                "Laporan Perkembangan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CardCatatan(number: 1, body: content(), title: "Aku"),
            SizedBox(
              height: 15,
            ),
            CardCatatan(number: 1, body: content(), title: "Panca Indra"),
            SizedBox(
              height: 15,
            ),
            CardCatatan(number: 1, body: content(), title: "Anggota Tubuh"),
            SizedBox(
              height: 15,
            ),
            CardCatatan(number: 1, body: content(), title: "Hobi"),
            SizedBox(
              height: 15,
            ),
            
          ],
        )
    );
  }

  Widget content(){
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text("Catatan:....", style: TextStyle(fontSize: 18)),
    );
  }

  
}