import 'package:flutter/material.dart';
import 'package:littlesteps/pages/roomchat_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class PesanPage extends StatelessWidget {
  final String role;
  final String kelasId;
  const PesanPage({super.key, required this.role, required this.kelasId});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    List<Map<String, dynamic>> chatPengumuman = [
      {
        'message':
            'Assalamualaikum ibu dan bapak sekalian, informasi untuk besok dalam rangka menyambut 17 agustus',
        'isSender': false,
        'time': '10:12',
      },
      {
        'message': '',
        'isSender': false,
        'imageUrl': 'assets/images/bendera.png',
        'time': '10:13',
      },
      {
        'message':
            'Diharapkan anak-anak membawa bendera merah putih seperti pada gambar. Terimakasih atas perhatiannya.',
        'isSender': false,
        'time': '10:14',
      },
    ];

    List<Map<String, dynamic>> chatPribadi = [
      {
        'message':
            'Assalamualaikum bu mira, hari ini Aisyah semangat sekali. Dia berani angkat tangan dan jawab pertanyaan lho!',
        'isSender': false,
        'time': '09:12',
      },
      {
        'message':
            'waalaikumsalam bu rani. Wah, senangnya dengar itu Bu. Di rumah juga lagi sering cerita soal sekolah',
        'isSender': true,
        'time': '10:13',
      },
    ];

    void tochatpribadi() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RoomChatPage(
                    isAnounce: false,
                    kelasId: kelasId,
                    role: role,
                  )));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.06, vertical: height * 0.04),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              width: double.infinity,
              height: width * 0.12,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () {},
                      icon: ImageIcon(AssetImage('assets/icons/Cari.png'))),
                ),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomChatPage(
                                isAnounce: true,
                                kelasId: kelasId,
                                role: role,
                              )));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color(0xFFFEF9E4),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('assets/icons/Pengumuman.png'),
                          size: 36,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Pengumuman",
                          style: TextStyle(
                              fontVariations: [FontVariation('wght', 800)],
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bubblePesan("Bu Rani", "walaikumsalam", "kemarin",
                  () => tochatpribadi(), "assets/images/Bu_cindy.png", context),
              bubblePesan("Bu Sinta", "betul bu anak saya juga", "10:00",
                  () => tochatpribadi(), "assets/images/Bu_mira.png", context),
              bubblePesan("Bu Cindy", "iya bu", "11:30", () => tochatpribadi(),
                  "assets/images/Bu_rani.png", context),
            ],
          ),
        ],
      ),
    );
  }

  Widget bubblePesan(String name, String pesan, String waktu,
      VoidCallback onTap, String imagePath, BuildContext context) {
    final width = DeviceDimensions.width(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    AssetImage(imagePath), // Pastikan gambar ada di path ini
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          waktu,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      pesan,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
