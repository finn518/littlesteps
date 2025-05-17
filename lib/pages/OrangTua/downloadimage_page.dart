import "package:flutter/material.dart";
import "package:littlesteps/utils/device_dimension.dart";
class DonwloadImagePage extends StatefulWidget {
  final String url;
  final String date;
  const DonwloadImagePage({super.key, required this.url, required this.date});

  @override
  State<DonwloadImagePage> createState() => _DonwloadImagePageState();
}

class _DonwloadImagePageState extends State<DonwloadImagePage> {
  
  @override
  Widget build(BuildContext context) {
     final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 36,
            )),
        title:  Text(
          widget.date,
          style: TextStyle(
              fontVariations: [FontVariation('wght', 800)], fontSize: 28),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {},
                icon: ImageIcon(AssetImage('assets/icons/download.png'))),
          )
        ],

      ),
      body: Container(
        margin: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(widget.url, fit: BoxFit.cover)
        ),
      ),
    );
  }
}