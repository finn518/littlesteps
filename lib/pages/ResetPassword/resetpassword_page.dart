import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';
import 'package:littlesteps/pages/ResetPassword/verifyOtp_page.dart';
import 'package:littlesteps/widgets/customtextfield.dart';


class ResetPasswordPage extends StatelessWidget {
  final String role;
  const ResetPasswordPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final nomorController = TextEditingController();
    return ResetPasswordFlow(title: "Lupa Kata Sandi?",
    subtitle: "Tidak perlu khawatir, kami mengerti ini bisa terjadi pada siapa saja. masukkan nomor telepon Anda untuk menerima kode OTP dan masuk kembali.",
      body: CustomTextField(
        label: "Nomor Telepon",
        controller: nomorController,
        isNumber: true,
      ),
    buttonText: "Lanjutkan",
    onButtonPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyOtpPage(role: role,)));
    },
    );
  }
}