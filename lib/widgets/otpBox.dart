import 'package:flutter/material.dart';

class OTPbox extends StatelessWidget {
  final FocusNode currentFocus;
  final FocusNode? nextFocus;

  const OTPbox({super.key, required this.currentFocus, this.nextFocus});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border.all(
        color: Colors.black, width: 1), 
        borderRadius: BorderRadius.circular(10), // Radius 10
      ),
      child: TextField(
        focusNode: currentFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
  }
}
