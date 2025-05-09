import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ProfilSiswa/detaillaporanperkembangan_page.dart';

class LaporanPerkembanganGuru extends StatefulWidget {
  final String role;
  const LaporanPerkembanganGuru({super.key, required this.role});

  @override
  State<LaporanPerkembanganGuru> createState() =>
      _LaporanPerkembanganGuruState();
}

class _LaporanPerkembanganGuruState extends State<LaporanPerkembanganGuru> {
  final List<Map<String, String>> _temaList = [
    {'judul': 'Diri Sendiri', 'bulan': 'Juli'},
    {'judul': 'Lingkungan', 'bulan': 'Agustus'},
    {'judul': 'Kebutuhan', 'bulan': 'September'},
    {'judul': 'Binatang', 'bulan': 'Oktober'},
  ];

  final judul = TextEditingController();
  final bulan = TextEditingController();

  void _showTambahTemaForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Buat Tema\nLaporan Perkembangan',
                  style: TextStyle(
                      fontSize: 24,
                      fontVariations: [FontVariation('wght', 800)]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: judul,
                  decoration: InputDecoration(
                    hintText: 'Judul Tema',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bulan,
                  decoration: InputDecoration(
                    hintText: 'Bulan Tema',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _temaList
                            .add({'judul': judul.text, 'bulan': bulan.text});
                      });
                      judul.clear();
                      bulan.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Buat Tema Laporan',
                      style: TextStyle(
                        fontVariations: [FontVariation('wght', 800)],
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == "Guru";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                'Laporan Perkembangan',
                style: TextStyle(
                    fontVariations: [FontVariation('wght', 800)], fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              itemCount: _temaList.length,
              itemBuilder: (context, index) {
                final tema = _temaList[index];
                return temaLaporanTile(
                  tema['judul']!,
                  tema['bulan']!,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailLaporanPerkembanganPage(
                              role: widget.role))),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: _showTambahTemaForm,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
              shape: const CircleBorder(),
            )
          : null,
    );
  }

  // void _onTemaTap(String judul, String bulan) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Klik tema: $judul - Bulan: $bulan')),
  //   );
  // }

  Widget temaLaporanTile(String judul, String bulan, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tema : $judul',
                style: TextStyle(
                    fontVariations: [FontVariation('wght', 800)],
                    fontSize: 22)),
            const SizedBox(height: 25),
            Text('Bulan : $bulan',
                style: TextStyle(
                    fontVariations: [FontVariation('wght', 800)],
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
