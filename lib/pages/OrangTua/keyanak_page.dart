import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/pages/ProfilSiswa/profilsiswa_page.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';
import 'package:littlesteps/widgets/customtextfield.dart';

class KeyAnakPage extends StatelessWidget {
  final String role;
  const KeyAnakPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Siswa newSiswa = Siswa(
    //     name: 'Siti Fatimah',
    //     imagePath: 'assets/images/siti.png',
    //     parentName: 'Bu Mira',
    //     isConnected: true);

    final keyController = TextEditingController();
    return ResetPasswordFlow(
      title: "Informasi Anak Anda Belum Terhubung",
      subtitle:
          "Silahkan masukkan kode teks yang telah diberikan guru anak anda",
      buttonText: "Lanjutkan",
      body: CustomTextField(label: "Kode Teks", controller: keyController),
      onButtonPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => ProfilSiswaPage(
        //               siswa: newSiswa,
        //               role: role,
        //             )));
      },
    );
  }
}
