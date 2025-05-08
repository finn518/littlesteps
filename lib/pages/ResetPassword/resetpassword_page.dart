import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';
import 'package:littlesteps/pages/success_page.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/widgets/customtextfield.dart';


class ResetPasswordPage extends StatefulWidget {
  final String role;
  const ResetPasswordPage({super.key, required this.role});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final authService = AuthService();
  final emailController = TextEditingController();

  Future<void> resetPasswordfun(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masukkan email anda')));
      return;
    }

    try {
      await authService.resetPassword(email: email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage(role: widget.role)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim reset password')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return ResetPasswordFlow(title: "Lupa Kata Sandi?",
    subtitle: "Tidak perlu khawatir, kami mengerti ini bisa terjadi pada siapa saja. masukkan nomor telepon Anda untuk menerima kode OTP dan masuk kembali.",
      body: CustomTextField(
          label: "Surel",
          controller: emailController,
      ),
        buttonText: "Reset Password",
        onButtonPressed: () => resetPasswordfun(context)
    );
  }
}

