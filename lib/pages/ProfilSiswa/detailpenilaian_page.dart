import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/rangkumanPenilaian.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailPenilaianPage extends StatefulWidget {
  final String role;
  final RangkumanPenilaian rangkuman;
  const DetailPenilaianPage(
      {super.key, required this.role, required this.rangkuman});

  @override
  State<DetailPenilaianPage> createState() => _DetailPenilaianPageState();
}

class _DetailPenilaianPageState extends State<DetailPenilaianPage> {
  void showDeleteDetailDialog(int indexToRemove) {
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
                "Apakah Anda yakin ingin menghapus laporan penilaian?",
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
                      await deleteDetailPenilaian(
                          widget.rangkuman.id, indexToRemove);
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

  Future<void> deleteDetailPenilaian(
      String idRangkumanPenilaian, int indexToRemove) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.rangkuman.kelasId)
          .collection('rangkumanPenilaian')
          .doc(idRangkumanPenilaian);

      // Buat array baru tanpa elemen di index tersebut
      List<String> newSubBab = List.from(widget.rangkuman.subBab);
      List<String> newNilai = List.from(widget.rangkuman.nilai);

      newSubBab.removeAt(indexToRemove);
      newNilai.removeAt(indexToRemove);

      // Update dokumen dengan array baru
      await docRef.update({
        'subBab': newSubBab,
        'nilai': newNilai,
      });

      setState(() {
        widget.rangkuman.subBab
          ..clear()
          ..addAll(newSubBab);
        widget.rangkuman.nilai
          ..clear()
          ..addAll(newNilai);
      });

      debugPrint("Detail penilaian berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus detail penilaian: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final subBab = widget.rangkuman.subBab;
    final nilai = widget.rangkuman.nilai;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.075),
        children: [
          Center(
            child: Text(
              "Laporan Penilaian",
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              widget.rangkuman.kompetensiDasar,
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 26,
                color: Color(0xff707070),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(subBab.length, (index) {
            final sub = subBab[index];
            final score =
                index < nilai.length ? nilai[index] : "Belum ada nilai";
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CardCatatan(
                reverse: true,
                number: index + 1,
                body: content(sub),
                title: score,
                onLongPress: widget.role == 'Guru'
                    ? () => showDeleteDetailDialog(index)
                    : null,
              ),
            );
          }),
        ],
      ),

      // floatingActionButton: isTeacher
      //     ? FloatingActionButton(
      //         onPressed: _showTambahPPenilaian,
      //         backgroundColor: Colors.blue,
      //         child: const Icon(Icons.add, color: Colors.white),
      //         shape: CircleBorder(),
      //       )
      //     : null,
    );
  }

  Widget content(String detail) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
            child: Text(
          detail,
          style: TextStyle(
            fontSize: 18,
            fontVariations: [FontVariation('wght', 800)],
          ),
          textAlign: TextAlign.center,
        )));
  }
}
