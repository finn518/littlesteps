import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class InputBar extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const InputBar({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.005),
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xff2A5677)),
            ),
          ),
          SizedBox(
            width: width * 0.7,
            height: height * 0.05,
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _isObscure : false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
