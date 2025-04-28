import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ResetPassword/confirmpassword.dart';
import 'package:littlesteps/pages/ResetPassword/resetPasswordflow.dart';
import 'package:littlesteps/widgets/otpBox.dart';


class VerifyOtpPage extends StatefulWidget {
  final String role;
  const VerifyOtpPage({super.key, required this.role});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();

   @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ResetPasswordFlow(
      title: "Verifikasi OTP", 
      subtitle: "Silakan masukkan kode yang telah kami kirimkan ke nomor telepon Anda",
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OTPbox(currentFocus: focusNode1, nextFocus: focusNode2,),
              OTPbox(currentFocus: focusNode2, nextFocus: focusNode3,),
              OTPbox(currentFocus: focusNode3, nextFocus: focusNode4,),
              OTPbox(currentFocus: focusNode4,)
            ],
          ),
          SizedBox(height: 20,)
        ],
      ), 
      sendAgain: true,
      buttonText: "Lanjutkan", 
      onButtonPressed: (){
        Navigator.push(
              context, MaterialPageRoute(builder: (_) => ConfirmPasswordPage(role: widget.role,)));
      }
    );
  }  
}