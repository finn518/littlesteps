import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool isNumber;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isNumber = false, // tambahkan default
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    double width = DeviceDimensions.width(context);
    double height = DeviceDimensions.height(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.008),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xff2A5677),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.infinity,
            height: height * 0.05,
            child: TextFormField(
              keyboardType:
                  widget.isNumber ? TextInputType.number : TextInputType.text,
              controller: widget.controller,
              obscureText: widget.isPassword ? _isObscure : false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Color(0xff2A5677), width: 1.5)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xff2A5677), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xff2A5677), width: 1.5),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          size: width * 0.05,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
