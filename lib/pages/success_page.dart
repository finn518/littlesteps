import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/pages/ProfilSiswa/profilsiswa_page.dart';
import 'package:littlesteps/pages/login_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';

class SuccessPage extends StatelessWidget {
  final Anak? anak;
  final String role;
  final bool isProfile;

  const SuccessPage(
      {super.key, required this.role, required this.isProfile, this.anak});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.12, vertical: height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar
              SizedBox(
                child: Image.asset('assets/icons/Berhasil.png'),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Berhasil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              // Deskripsi
              const Text(
                'Selamat! Anda telah berhasil terhubung dengan\n'
                'informasi anak anda. Silakan klik "Lanjutkan"\n'
                'untuk melihat informasi anak.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Lanjutkan
              CustomButton(
                label: "Lanjutkan",
                onPressed: () {
                  if (isProfile) {
                    if (anak == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Data anak tidak tersedia")),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilSiswaPage(
                          siswa: anak!,
                          role: role,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(role: role),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
