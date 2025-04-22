import 'package:flutter/material.dart';
import 'package:littlesteps/utils/auth_gate.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class RolePage extends StatelessWidget {
  RolePage({super.key});
  late final _deviceWidht, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidht = DeviceDimensions.width(context);
    _deviceHeight = DeviceDimensions.height(context);
    return SafeArea(
      child: Container(
        width: _deviceWidht,
        height: _deviceHeight,
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xff84CAFF),
            Colors.white, // Biru muda
            Colors.white, // Kuning pastel
            Color(0xffFDE272),
          ],
          stops: [0.0, 0.58, 0.67, 1],
        ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                "assets/splash.png",
                width: 200,
                height: 200,
              ),
              Padding(
                padding:  EdgeInsets.only(bottom: _deviceHeight * 0.012, top: _deviceHeight * 0.2), //Besok Ganti jadi device height * ...
                child: Text(
                  "Siapakah Anda ?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ],
            ),
            roleBtn("Pengajar", AuthGate(role: "Guru",)),
            roleBtn("Orang Tua", AuthGate(role: "Orang Tua",)),
          ],
        ),
      )
    );
  }

  Widget roleBtn(String name, Widget halaman) {
    return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
          width: 300,
          height: 60,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => halaman),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Color(0xFF53B1FD), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _deviceHeight * 0.013,
                vertical: _deviceHeight * 0.018,
              ),
            ),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}