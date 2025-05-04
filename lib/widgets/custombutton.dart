import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = DeviceDimensions.height(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: double.infinity,
      height: height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0066FF),
          foregroundColor: const Color(0xffFEFEFE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
