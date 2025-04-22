import 'package:flutter/material.dart';
import 'package:littlesteps/pages/resetPassword_page.dart';
import 'package:littlesteps/pages/signup_page.dart';
import 'package:littlesteps/utils/auth.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/button.dart';
import 'package:littlesteps/widgets/edittext.dart';
import 'package:littlesteps/utils/auth_gate.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //get Auth Service
  final authService = AuthService();

  //text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //check login
  void login() async{
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // await authService.signInWithEmail(email, password);
      await authService.signInWithEmail(email: email, password: password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  }

  void loginGoogle(String role) async{
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.07, bottom: height * 0.015),
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Center(child: InputBar(label: "Surel atau Nomor Telepon", controller: emailController,)),
                    Center(child: InputBar(label: "Kata Sandi", isPassword: true, controller: passwordController,)),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.015, left: height * 0.25),
                      child: GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                      },
                      child: Text("Lupa Kata Sandi ?", style: TextStyle(fontSize: 14, color: Color(0xff0066FF),fontWeight: FontWeight.bold)),),
                    ),
                    CustomButton(width: width, height: height,label:  "Masuk", onPressed: login),
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
                margin: EdgeInsets.symmetric(vertical: height * 0.2 ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Apakah anda tidak memiliki akun",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    CustomButton(width: width, height: height,label:  "Buat Akun", onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage(role: widget.role)));
                    }),
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