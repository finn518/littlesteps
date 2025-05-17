import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/model/temaLaporan.dart';
import 'package:littlesteps/pages/ProfilSiswa/detaillaporanperkembangan_page.dart';

class LaporanPerkembanganGuru extends StatefulWidget {
  final String role;
  final Anak siswa;
  const LaporanPerkembanganGuru(
      {super.key, required this.role, required this.siswa});

  @override
  State<LaporanPerkembanganGuru> createState() =>
      _LaporanPerkembanganGuruState();
}

class _LaporanPerkembanganGuruState extends State<LaporanPerkembanganGuru> {
  Future<void> _uploadTemaLaporan(TemaLaporan laporan) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.siswa.idKelas)
          .collection('anak')
          .doc(widget.siswa.id)
          .collection('laporanPerkembangan')
          .doc();

      await docRef.set({
        'id': docRef.id,
        'siswaId': laporan.siswaId,
        'tema': laporan.tema,
        'bulan': laporan.bulan,
      });

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error uploading tema laporan perkembangan: $e');
    }
  }

  void _showTambahTemaForm() {
    final TextEditingController judul = TextEditingController();
    final TextEditingController bulan = TextEditingController();

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
                _buildTextField(judul, 'Judul Tema'),
                const SizedBox(height: 12),
                _buildTextField(bulan, 'Bulan Tema'),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (judul.text.isEmpty || bulan.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Semua field harus diisi')),
                        );
                        return;
                      }

                      final laporan = TemaLaporan(
                          id: '',
                          siswaId: widget.siswa.id,
                          tema: judul.text,
                          bulan: bulan.text);

                      await _uploadTemaLaporan(laporan);
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black),
          ),
        ));
  }

  void showDeleteLaporanDialog(BuildContext context, String idLaporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah Anda yakin ingin menghapus tema laporan?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Ya
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xff0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Tutup dialog
                      await deleteLaporan(idLaporan);
                    },
                    child: const Text("Ya",
                        style: TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Colors.white,
                            fontSize: 18)),
                  ),
                  const SizedBox(width: 16),
                  // Tombol Tidak
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () => Navigator.pop(context), // Tutup dialog
                    child: const Text("Tidak",
                        style: TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Color(0xff0066FF),
                            fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteLaporan(String idLaporan) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.siswa.idKelas)
          .collection('anak')
          .doc(widget.siswa.id)
          .collection('laporanPerkembangan')
          .doc(idLaporan);
      await docRef.delete();
      setState(() {});

      debugPrint("Laporan berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus Laporan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == "Guru";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
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
                    fontVariations: [FontVariation('wght', 800)], fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('kelas')
                  .doc(widget.siswa.idKelas)
                  .collection('anak')
                  .doc(widget.siswa.id)
                  .collection('laporanPerkembangan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('Belum ada laporan perkembangan.'));
                }
                final List<String> bulanUrutan = [
                  'Januari',
                  'Februari',
                  'Maret',
                  'April',
                  'Mei',
                  'Juni',
                  'Juli',
                  'Agustus',
                  'September',
                  'Oktober',
                  'November',
                  'Desember'
                ];

                docs.sort((a, b) {
                  final dataA = a.data() as Map<String, dynamic>;
                  final dataB = b.data() as Map<String, dynamic>;

                  final bulanA = dataA['bulan'] ?? '';
                  final bulanB = dataB['bulan'] ?? '';

                  int indexA = bulanUrutan.indexOf(bulanA);
                  int indexB = bulanUrutan.indexOf(bulanB);

                  if (indexA == -1) indexA = 999;
                  if (indexB == -1) indexB = 999;

                  return indexA.compareTo(indexB);
                });

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final idLaporan = docs[index].id;
                    final judul = data['tema'] ?? '';
                    final bulan = data['bulan'] ?? '';

                    return temaLaporanTile(
                      judul: judul,
                      bulan: bulan,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailLaporanPerkembanganPage(
                              role: widget.role,
                              siswa: widget.siswa,
                              temaId: idLaporan,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (isTeacher) {
                          showDeleteLaporanDialog(context, idLaporan);
                        }
                      },
                    );
                  },
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

  Widget temaLaporanTile(
      {required String judul,
      required String bulan,
      required VoidCallback onTap,
      required VoidCallback onLongPress}) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
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
