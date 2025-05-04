import 'package:flutter/material.dart';

class CardBantuan extends StatelessWidget {
  final String question;
  final String answer;
  const CardBantuan({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black, width: 1)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Q: $question',
              style: TextStyle(
                fontSize: 16,
                fontVariations: [FontVariation('wght', 500)],
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "A: $answer",
              style: TextStyle(
                fontSize: 16,
                fontVariations: [FontVariation('wght', 500)],
              ),
            )
          ],
        ),
      ),
    );
  }
}