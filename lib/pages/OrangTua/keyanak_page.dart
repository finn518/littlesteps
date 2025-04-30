import 'package:flutter/material.dart';
import 'package:littlesteps/pages/OrangTua/informasiAnak_page.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';
import 'package:littlesteps/widgets/customtextfield.dart';


class KeyAnakPage extends StatelessWidget {
  const KeyAnakPage({super.key});

  @override
  Widget build(BuildContext context) {
    final keyController = TextEditingController();
    return ResetPasswordFlow(
      title: "Informasi Anak Anda Belum Terhubung", 
      subtitle: "Silahkan masukkan kode teks yang telah diberikan guru anak anda", 
      buttonText: "Lanjutkan", 
      body: CustomTextField(label: "Kode Teks", controller: keyController),
      onButtonPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => InformasiAnakPage()));
      },
    );
  }
}