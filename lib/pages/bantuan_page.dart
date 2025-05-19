import 'package:flutter/material.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/widgets/cardBantuan.dart';

class BantuanPage extends StatelessWidget {
  final bool? isGuru;
  final String role;
  const BantuanPage({super.key, this.isGuru, required this.role});

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

    List listBantuanGuru = [
      {
        'question': "Apa kegunaan aplikasi ini ?",
        'answer':
            "Aplikasi ini adalah platform pembelajaran yang dirancang untuk membantu guru dalam membuat laporan perkembangan anak-anak yang sedang belajar, dan juga dapat memantau perkembangan anak."
      },
      {
        'question': "Bagaimana cara membuat laporan perkembangan anak? ",
        'answer':
            "Anda dapat memilih kelas anak yang akan dibuat, lalu Anda dapat memilih salah satu anak yang ada di kelas atau membuat profil anak dengan tombol “plus / tambah” di pojok kanan bawah. Setelah masuk ke dalam profil anak Anda dapat memilih perkembangan yang ingin dibuat. Pilihannya adalah “Catatan Kesehatan”, “Laporan Perkembangan”, dan “Rangkuman Penilaian”."
      },
      {
        'question': "Bagaimana mengupload kegiatan anak saat ini ? ",
        'answer':
            "Anda dapat melihatnya pada bagian menu bawah di halaman utama bertulisakan gallery. Setelah membuka halaman gallery, Anda dapat mengupload kegiatan yang sedang dilakukan dengan tombol “tambah” pada pojok kanan bawah. Anda dapat menulisskan deskripsi kegiatan dan menambahkan foto atau video yang bersangkutan dengan kegiatan tersebut."
      },
    ];

    final List listBantuanToShow =
        isGuru == true ? listBantuanGuru : listBantuan;
    return Scaffold(
       appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (role == "Guru") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KelasPage(role: role)),
                    (route) => false,
                  );
                } else if (role == "Orang Tua") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageOrangTua(role: role)),
                    (route) => false,
                  );
                }
              },
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
          itemCount: listBantuanToShow.length,
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
                CardBantuan(
                  question: listBantuanToShow[index]['question'],
                  answer: listBantuanToShow[index]['answer'],
                ),
              SizedBox(height: 15,)
            ],
          );
        },
      )
    );
  }
}