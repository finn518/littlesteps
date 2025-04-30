import 'package:flutter/material.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';
import 'package:littlesteps/widgets/postcard.dart';


class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        calenderBtn(context),
        PostCard(),
        PostCard(),
      ]
    );
  }


  Widget calenderBtn(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push((context), MaterialPageRoute(builder: (context) => JadwalHarianPage()));
        },
        child: Container(
      decoration: BoxDecoration(
        color: Color(0xffB2DDFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 60,
            height: 45,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xff53B1FD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ImageIcon(AssetImage('assets/icons/Jadwal_harian.png'),color: Colors.white,)
          ),
  
          Text(
            "Jadwal Harian",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
                  SizedBox(width: 50),
        ],
      ),
        ),
      ),
    );
  }
}