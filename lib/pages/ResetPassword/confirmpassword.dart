import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ResetPassword/newPassword_page.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';


class ConfirmPasswordPage extends StatelessWidget {
  final String role;
  const ConfirmPasswordPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ResetPasswordFlow(
      title: "Pengaturan Ulang Kata Sandi", 
      subtitle: "Kata sandi Anda telah berhasil diatur ulang. Silakan klik untuk membuat kata sandi baru", 
      buttonText: "Konfirmasi", 
      onButtonPressed: () {
        Navigator.push(
              context, MaterialPageRoute(builder: (_) => NewPasswordPage(role: role,)));
      },
    );
  }
}