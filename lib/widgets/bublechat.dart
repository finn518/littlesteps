import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class BubbleChat extends StatelessWidget {
  final String message;
  final bool isSender;
  final String? imageUrl;
  final String time;
  final VoidCallback? onLongPress;

  const BubbleChat(
      {Key? key,
      required this.message,
      required this.isSender,
      this.imageUrl,
      required this.time,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final bgColor = isSender ? Colors.white : Color(0xff8ED8FA);
    final align = isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isSender
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );

    return Column(
      crossAxisAlignment: align,
      children: [
        GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            constraints: BoxConstraints(maxWidth: width * 0.8),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Rounded corners for image
                    child: Image.network(
                      imageUrl!,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 100, color: Colors.grey);
                      },
                    ),
                  ),
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 2, bottom: 8, left: 10, right: isSender ? 10 : 0),
          child: Text(
            time,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xff8A9099),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }
}
