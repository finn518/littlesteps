import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/pages/ResetPassword/resetpassword_page.dart';
import 'package:littlesteps/pages/role_page.dart';
import 'package:littlesteps/pages/signup_page.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get Auth Service
  final authService = AuthService();

  // text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // check login
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final error = await authService.signInWithEmail(
      email: email,
      password: password,
      selectedRole: widget.role,
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      if (widget.role == 'Guru') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => KelasPage(role: widget.role),
          ),
        );
      } else if (widget.role == 'Orang Tua') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageOrangTua(role: widget.role),
          ),
        );
      }
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
              builder: (context) => KelasPage(role: widget.role),
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
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => RolePage())),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.1, vertical: height * 0.01),
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 32,
                          fontVariations: [FontVariation('wght', 800)],
                        ),
                      ),
                    ),
                    Center(
                        child: CustomTextField(
                      label: "Surel atau Nomor Telepon",
                      controller: emailController,
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: CustomTextField(
                      label: "Kata Sandi",
                      isPassword: true,
                      controller: passwordController,
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(
                                role: widget.role,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Lupa Kata Sandi ?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff0066FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    CustomButton(label: "Masuk", onPressed: login),
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
                margin: EdgeInsets.only(top: height * 0.2),
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
                        label: "Buat Akun",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignupPage(role: widget.role)));
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
