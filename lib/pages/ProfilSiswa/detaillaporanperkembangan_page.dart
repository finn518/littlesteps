import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailLaporanPerkembanganPage extends StatefulWidget {
  final String role;
  const DetailLaporanPerkembanganPage({super.key, required this.role});

  @override
  State<DetailLaporanPerkembanganPage> createState() =>
      _DetailLaporanPerkembanganPageState();
}

class _DetailLaporanPerkembanganPageState
    extends State<DetailLaporanPerkembanganPage> {
  final judul = TextEditingController();
  final catatan = TextEditingController();

  void _showTambahPerkembangan() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Buat Laporan \nPerkembangan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // TextField for 'judul'
                  TextField(
                    controller: judul,
                    decoration: InputDecoration(
                      hintText: 'Tulis judul Anda disini...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: catatan,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tulis catatan Anda disini...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Debugging: Print values when submitting
                        print('Judul: ${judul.text}');
                        print('Catatan: ${catatan.text}');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Buat Laporan Perkembangan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == 'Guru';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 48),
        children: [
          Center(
            child: Text(
              "Laporan Perkembangan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CardCatatan(number: 1, body: content(), title: "Aku"),
          SizedBox(
            height: 15,
          ),
          CardCatatan(number: 1, body: content(), title: "Panca Indra"),
          SizedBox(
            height: 15,
          ),
          CardCatatan(number: 1, body: content(), title: "Anggota Tubuh"),
          SizedBox(
            height: 15,
          ),
          CardCatatan(number: 1, body: content(), title: "Hobi"),
          SizedBox(
            height: 15,
          ),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: _showTambahPerkembangan,
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
              shape: CircleBorder(),
            )
          : null,
    );
  }

  Widget content() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text("Catatan:....", style: TextStyle(fontSize: 18)),
    );
  }
}
