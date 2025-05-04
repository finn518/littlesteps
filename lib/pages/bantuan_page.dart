import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardBantuan.dart';


class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    List listBantuan = [
      {'question': "Apa itu aplikasi littlestep ? ", 
        'answer': "Aplikasi ini adalah platform pembelajaran yang dirancang untuk membantu orang tua memantau  anak-anak belajar dengan cara yang efektif dan interaktif."
      },
      {'question': "Bagaimana cara memantau perkembangan anak saya? ", 
        'answer': "Anda dapat melihat laporan kemajuan anak, nilai-nilai tugas, dan aktivitas pembelajaran melalui dashboard khusus orang tua, untuk membuka nya anda dapat membuka profil di pojok kiri atas lalu pilih bagian informasi anak."
      },
      {'question': "Bagaimana saya mengakses foto / video kegiatan anak saya ? ", 
        'answer': "Anda dapat melihatnya pada bagian menu bawah di halaman utama bertulisakan gallery. Setelah dibuka anda dapat melihat sesuai bulannya."
      },
      {'question': "Bagaimana cara keluar dari akun ?", 
        'answer': "Pada halaman utama anda dapat membuka menu sidebar dengan mengklik profil, lalu pilih bagian keluar akun"
      },

    ];
    return Scaffold(
       appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
        title: Text(
            "Bantuan",
            style: TextStyle(
                fontVariations: [FontVariation('wght', 800)], fontSize: 28),
          ),
          centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listBantuan.length,
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
              CardBantuan(question: listBantuan[index]['question'], answer: listBantuan[index]['answer']),
              SizedBox(height: 15,)
            ],
          );
        },
      )
    );
  }
}