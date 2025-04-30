import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';

class ResetPasswordFlow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? body;
  final String buttonText;
  final bool? sendAgain;
  final VoidCallback onButtonPressed;

  const ResetPasswordFlow({
    super.key,
    required this.title,
    required this.subtitle,
    this.sendAgain,
    this.body,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 36,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.12, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 20),
            if (body != null) body!,
            CustomButton(
              label: buttonText,
              onPressed: onButtonPressed,
            ),
            if (sendAgain == true) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum menerima kode?"),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      // TODO: isi fungsi kirim ulang kalau mau
                    },
                    child: const Text(
                      "Kirim ulang",
                      style: TextStyle(
                          color: Color(0xff4285F4), fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
