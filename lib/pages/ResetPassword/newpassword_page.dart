import "package:flutter/material.dart";
import "package:littlesteps/pages/ResetPassword/resetPasswordflow.dart";
import "package:littlesteps/pages/success_page.dart";
import "package:littlesteps/widgets/customtextfield.dart";


class NewPasswordPage extends StatelessWidget {
  final String role;
  const NewPasswordPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return ResetPasswordFlow(
      title: "Buat Kata Sandi Baru", 
      subtitle: "Silakan buat kata sandi baru. Pastikan berbeda dari kata sandi sebelumnya demi keamanan", 
      buttonText: "Lanjutkan",
      body: Column(
        children: [
          CustomTextField(label: "Kata sandi", controller: passwordController),
          CustomTextField(label: "Konfirmasi Kata sandi", controller: confirmPasswordController),
        ],
      ), 
      onButtonPressed: (){
        Navigator.push(
              context, MaterialPageRoute(builder: (_) => SuccessPage(role: role, isProfile: false,)));
      }
    );
  }
}

