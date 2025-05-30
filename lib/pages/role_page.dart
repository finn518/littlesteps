import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:littlesteps/pages/login_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  double _deviceWidth = 0;
  double _deviceHeight = 0;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = DeviceDimensions.width(context);
    _deviceHeight = DeviceDimensions.height(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _deviceWidth,
          height: _deviceHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xffD1E9FF),
                Colors.white,
                Colors.white,
                Color(0xBFFEF7C3),
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
                    "assets/images/LOGO_FINAL.png",
                    width: 350,
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: _deviceHeight * 0.012,
                      left: _deviceWidth * 0.15,
                      right: _deviceWidth * 0.15,
                      top: _deviceHeight * 0.2,
                    ),
                    child: const Text(
                      "Siapakah Anda ?",
                      style: TextStyle(
                        fontSize: 28,
                        fontVariations: [FontVariation('wght', 800)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              roleBtn("Guru"),
              roleBtn("Orang Tua"),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleBtn(String name) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(role: name)),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Color(0xFF53B1FD), width: 2),
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
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

