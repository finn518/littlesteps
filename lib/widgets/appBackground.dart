import 'package:flutter/widgets.dart';
import "package:flutter/material.dart";

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xffD1E9FF),
            Colors.white,
            Colors.white,
            Color(0xBFFEF7C3),
          ],
          stops: [0.0, 0.58, 0.67, 1],
        ),
      ),
      child: child,
    );
  }
}
