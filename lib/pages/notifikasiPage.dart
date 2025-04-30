import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  final String role;

  const NotifikasiPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xFFF6FDFF),
        appBar: AppBar(
          backgroundColor: Color(0xFFF6FDFF),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                role == "Guru" ? "Notifikasi Guru" : "Notifikasi Orang Tua",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Expanded(
                child: Container(
              child: ListView(
                children: [...buildNotifikasiList(role)],
              ),
            ))
          ],
        ));
  }

  List<Widget> buildNotifikasiList(String role) {
    if (role == "Guru") {
      return [
        notifikasiTile(
          imagePath: 'assets/images/Bu_mira.png',
          title:
              'Orang tua Siti Fatimah (Bu Mira) telah bergabung di kelas Anda',
          time: 'Hari ini 09.01',
        ),
        notifikasiTile(
            imagePath: 'assets/images/Bu_cindy.png',
            title: 'Orang tua Uni (Bu Cindy) telah bergabung di kelas Anda',
            time: 'Hari ini 08:47'),
        notifikasiTile(
            imagePath: 'assets/images/Pak_Haji.png',
            title: 'Orang tua Mada (Pak Haji) telah bergabung di kelas Anda',
            time: 'Kemarin 11:30'),
      ];
    } else {
      return [
        notifikasiTile(
            imagePath: 'assets/images/Bu_rani.png',
            title: 'Bu Rani telah membuat pengumuman baru',
            time: 'Hari ini 10:12'),
      ];
    }
  }

  Widget notifikasiTile(
      {required String imagePath,
      required String title,
      required String time}) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: AssetImage(imagePath)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ))
        ],
      ),
    );
  }
}
