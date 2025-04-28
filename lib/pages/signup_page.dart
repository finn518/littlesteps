import 'package:flutter/material.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';
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
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
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
          padding: EdgeInsets.only(
              left: width * 0.13,
              right: width * 0.13,
              bottom: MediaQuery.of(context).viewInsets.bottom), // ini penting
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
                    Center(
                        child: CustomTextField(
                            label: "Surel", controller: emailController)),
                    Center(
                        child: CustomTextField(
                            label: "Nomor Telepon",
                            isNumber: true,
                            controller: nomorteleponController)),
                    Center(
                        child: CustomTextField(
                            label: "Kata Sandi",
                            isPassword: true,
                            controller: passwordController)),

                    CustomButton(
                        label: "Buat Akun",
                        onPressed: signUp),

                    Center(
                      child: Text(
                        "Atau lanjutkan dengan Google",
                        style: TextStyle(fontSize: 12),
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
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    CustomButton(
                      label: "Masuk",
                      onPressed: () {
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