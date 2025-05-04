import 'package:flutter/material.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/postcard.dart';


class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return ListView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.01),
      children: [
        calenderBtn(context),
        PostCard(),
        PostCard(),
      ]
    );
  }


  Widget calenderBtn(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015),
      child: GestureDetector(
        onTap: () {
          Navigator.push((context),
              MaterialPageRoute(builder: (context) => JadwalHarianPage()));
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
                  child: ImageIcon(
                    AssetImage('assets/icons/Jadwal_harian.png'),
                    color: Colors.white,
                  )),
              Text(
                "Jadwal Harian",
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 800)],
                  fontSize: 16,
                  color: Colors.black,
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