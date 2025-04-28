import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(padding: EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 24), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                "Cerita",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 10,),
              uploader(),
              SizedBox(height: 10),
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
            Text("Prof. Alfin", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("28 - feb - 2025"),
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
        SizedBox(height: 20,),
        Text(
          "Foto Kegiatan Sekolah",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            Text("Suka", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
          ],
        ),
        Row(
          children: [
            ImageIcon(AssetImage('assets/icons/komen.png')),
            SizedBox(width: 10),
            Text("Comment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}