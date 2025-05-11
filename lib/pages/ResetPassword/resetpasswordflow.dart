import 'package:flutter/material.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';

class ResetPasswordFlow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? body;
  final String buttonText;
  final bool? sendAgain;
  final bool? isLogin; 
  final VoidCallback onButtonPressed;

  const ResetPasswordFlow({
    super.key,
    required this.title,
    required this.subtitle,
    this.sendAgain,
    this.body,
    this.isLogin,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
      appBar: AppBar(
        leading: isLogin == true
            ? IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePageOrangTua(role: "Orang Tua"),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.arrow_back, size: 36),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 36),
              ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.075, vertical: height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontVariations: [FontVariation('wght', 800)],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
            ],
            const SizedBox(height: 30),
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
