import 'package:flutter/material.dart';

class CardCatatan extends StatelessWidget {
  final bool? reverse;
  final int number;
  final String title;
  final Widget body;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CardCatatan({
    super.key,
    required this.number,
    required this.body,
    required this.title,
    this.reverse,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isReversed = reverse ?? false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: isReversed
              ? null // No border radius when reversed
              : BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isReversed ? _buildReversedLayout() : _buildNormalLayout(),
        ),
      ),
    );
  }

  List<Widget> _buildNormalLayout() {
    return [
      Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 500)],
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontVariations: [FontVariation('wght', 700)],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Divider(
        color: Colors.black,
        height: 1,
        thickness: 1,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: body,
      ),
    ];
  }

  List<Widget> _buildReversedLayout() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: body,
      ),
      Divider(
        color: Colors.black,
        height: 1,
        thickness: 1,
      ),
      Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 500)],
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
