import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, left: width * 0.015),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back), iconSize: width * 0.1,),
          )
        ],
      )
    );
  }
}