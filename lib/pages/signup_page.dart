import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';

class SignupPage extends StatefulWidget {
  final String role;
  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
//get Auth Service
  final authService = AuthService();

  //text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();
  final nomorteleponController = TextEditingController();

  //check login
  void signUp() async {
    //prepare data
    final email = emailController.text;
    final password = passwordController.text;
    final nama = namaController.text;
    final nomor = nomorteleponController.text;

    if (nama.isEmpty || email.isEmpty || password.isEmpty || nomor.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    try {
      final user = await AuthService().signUpWithEmail(
        email,
        password,
      );

      if (user != null) {
        await AuthService()
            .saveUserData(user.uid, nama, email, nomor, widget.role);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil registrasi. Silahkan Verifikasi Email Anda',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
        ),
      );
    }
  }

  void loginGoogle(String role) async {
    try {
      await authService.signInWithGoogle(role: role);
      if (mounted) {
        if (widget.role == 'Guru') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => KelasPage(role: widget.role),
            ),
          );
        } else if (widget.role == "Orang Tua") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageOrangTua(role: widget.role),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      resizeToAvoidBottomInset:
          true, // biar scaffold menyesuaikan saat keyboard muncul
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.1, vertical: height * 0.01), // ini penting
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .start, // jangan spaceBetween karena bakal tinggi banget
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      child: Text(
                        "Buat Akun ${widget.role}",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Center(
                        child: CustomTextField(
                            label: "Nama", controller: namaController)),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: CustomTextField(
                            label: "Surel", controller: emailController)),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: CustomTextField(
                            label: "Nomor Telepon",
                            isNumber: true,
                            controller: nomorteleponController)),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: CustomTextField(
                            label: "Kata Sandi",
                            isPassword: true,
                            controller: passwordController)),
                    CustomButton(label: "Buat Akun", onPressed: signUp),
                    Center(
                      child: Text(
                        "Atau lanjutkan dengan Google",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.12,
                      height: height * 0.08,
                      child: IconButton(
                        onPressed: () => loginGoogle(widget.role),
                        icon: Image.asset("assets/icons/Google_Icon.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.05),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Apakah anda tidak memiliki akun",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    CustomButton(
                      label: "Masuk",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
