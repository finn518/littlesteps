import 'package:flutter/material.dart';
import 'package:littlesteps/utils/auth.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/button.dart';
import 'package:littlesteps/widgets/edittext.dart';
import 'package:littlesteps/utils/auth_gate.dart';

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
  void signUp() async{
    //prepare data
    final email = emailController.text;
    final password = passwordController.text;
    final nama = namaController.text;
    final nomor = nomorteleponController.text;

    try {
      await authService.signUpWithEmail(email: email, password: password, name: nama, nomer: nomor, role: widget.role);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthGate(role: widget.role),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  }

  void loginGoogle(String role) async {
    try {
      await authService.signInWithGoogle(role: role);
      if (mounted) {
        // Ganti halaman jika berhasil login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthGate(role: widget.role),
          ),
        ); // atau halaman tujuanmu
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
      resizeToAvoidBottomInset:
          true, // biar scaffold menyesuaikan saat keyboard muncul
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom), // ini penting
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .start, // jangan spaceBetween karena bakal tinggi banget
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.07, bottom: height * 0.015),
                      child: Text(
                        "Buat Akun ${widget.role}",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800),
                      ),
                    ),
                   Center(
                        child: InputBar(
                            label: "Nama", controller: namaController)),
                    Center(
                        child: InputBar(
                            label: "Surel", controller: emailController)),
                    Center(
                        child: InputBar(
                            label: "Nomor Telepon",
                            controller: nomorteleponController)),
                    Center(
                        child: InputBar(
                            label: "Kata Sandi",
                            isPassword: true,
                            controller: passwordController)),

                    CustomButton(
                        width: width,
                        height: height,
                        label: "Buat Akun",
                        onPressed: signUp),

                    Center(
                      child: Text(
                        "Atau lanjutkan dengan Google",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                      height: height * 0.1,
                      child: IconButton(
                        onPressed: () => loginGoogle(widget.role),
                        icon: Image.asset("assets/gIcon.png"),
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
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    CustomButton(width: width,height: height,label: "Masuk", onPressed: () {
                      Navigator.pop(context);
                    },),
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