import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.06, vertical: height * 0.025),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                "Cerita",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontVariations: [FontVariation('wght', 800)], fontSize: 24),
              ),
              SizedBox(height: 10,),
              uploader(),
              SizedBox(height: 15),
              foto(),
              SizedBox(height: 30),
              postAction()


        ],
      )),
    );
  }

  Widget uploader(){
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/Bu_cindy.png'),
          radius: 20,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prof. Alfin",
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 800)],
                )),
            Text("28 - feb - 2025",
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 800)],
                )),
          ],
        ),
      ],
    );
  }
  Widget foto(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/GAMBAR_UPLOAD_FEBRUARI.png'),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Foto Kegiatan Sekolah",
          style: TextStyle(
              fontVariations: [FontVariation('wght', 800)], fontSize: 16),
        )

      ],
    );
  }

  Widget postAction(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            ImageIcon(AssetImage('assets/icons/suka.png')),
            SizedBox(width: 10),
            Text("Suka",
                style: TextStyle(
                  fontSize: 16,
                  fontVariations: [FontVariation('wght', 800)],
                )),
          ],
        ),
        Row(
          children: [
            ImageIcon(AssetImage('assets/icons/komen.png')),
            SizedBox(width: 10),
            Text("Comment",
                style: TextStyle(
                  fontSize: 16,
                  fontVariations: [FontVariation('wght', 800)],
                )),
          ],
        ),
      ],
    );
  }
}