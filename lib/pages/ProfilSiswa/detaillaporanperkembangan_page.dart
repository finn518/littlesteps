import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/model/detailLaporan.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailLaporanPerkembanganPage extends StatefulWidget {
  final String role;
  final Anak siswa;
  final String temaId;
  const DetailLaporanPerkembanganPage(
      {super.key,
      required this.role,
      required this.siswa,
      required this.temaId});

  @override
  State<DetailLaporanPerkembanganPage> createState() =>
      _DetailLaporanPerkembanganPageState();
}

class _DetailLaporanPerkembanganPageState
    extends State<DetailLaporanPerkembanganPage> {
  Future<void> _uploadUpdateDetailLaporan(DetailLaporan detailLaporan) async {
    try {
      final siswa = widget.siswa;
      final siswaId = siswa.id;
      final kelasId = siswa.idKelas;

      DocumentReference docRef;
      if (detailLaporan.id!.isNotEmpty) {
        //update yak
        docRef = FirebaseFirestore.instance
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(siswaId)
            .collection('laporanPerkembangan')
            .doc(widget.temaId)
            .collection('detailLaporan')
            .doc(detailLaporan.id);
      } else {
        // ini yg upload baru
        docRef = FirebaseFirestore.instance
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(siswaId)
            .collection('laporanPerkembangan')
            .doc(widget.temaId)
            .collection('detailLaporan')
            .doc();
      }

      await docRef.set({
        'id': docRef.id,
        'temaId': widget.temaId,
        'judul': detailLaporan.judul,
        'catatan': detailLaporan.catatan,
        'createdAt': DateTime.now()
      });

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error uploading data: $e');
    }
  }

  void _showTambahEditPerkembangan(
      BuildContext context, DetailLaporan? detailLaporan) {
    final judul = TextEditingController(text: detailLaporan?.judul ?? '');
    final catatan = TextEditingController(text: detailLaporan?.catatan ?? '');
    final isEdit = detailLaporan != null;

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
                  Text(
                    isEdit
                        ? 'Edit Laporan \nPerkembangan'
                        : 'Buat Laporan \nPerkembangan',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // TextField utk judul
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
                        final updatedDetail = DetailLaporan(
                            id: detailLaporan?.id ?? '',
                            temaId: detailLaporan?.temaId ?? '',
                            judul: judul.text.trim(),
                            catatan: catatan.text.trim(),
                            createdAt: isEdit
                                ? detailLaporan!.createdAt
                                : DateTime.now());
                        _uploadUpdateDetailLaporan(updatedDetail);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isEdit
                            ? 'Edit Laporan Perkembangan'
                            : 'Buat Laporan Perkembangan',
                        style: const TextStyle(
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

  void showDeleteDetailLaporanDialog(
      BuildContext context, String idDetailLaporan) {
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
                "Apakah Anda yakin ingin menghapus catatan laporan?",
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
                      await deleteDetailLaporan(idDetailLaporan);
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

  Future<void> deleteDetailLaporan(String idDetailLaporan) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.siswa.idKelas)
          .collection('anak')
          .doc(widget.siswa.id)
          .collection('laporanPerkembangan')
          .doc(widget.temaId)
          .collection('detailLaporan')
          .doc(idDetailLaporan);
      await docRef.delete();
      setState(() {});

      debugPrint("Catatan Kesehatan berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus Catatan Kesehatan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final isTeacher = widget.role == 'Guru';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Laporan Perkembangan",
              style: TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('kelas')
                      .doc(widget.siswa.idKelas)
                      .collection('anak')
                      .doc(widget.siswa.id)
                      .collection('laporanPerkembangan')
                      .doc(widget.temaId)
                      .collection('detailLaporan')
                      .orderBy('createdAt', descending: false)
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
                          child: Text('Belum ada detail laporan'));
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          final detail = DetailLaporan.fromMap(data);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardCatatan(
                              number: index + 1,
                              title: detail.judul,
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Catatan:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(detail.catatan),
                                ],
                              ),
                              onTap: isTeacher
                                  ? () {
                                      _showTambahEditPerkembangan(
                                          context, detail);
                                    }
                                  : null,
                              onLongPress: isTeacher
                                  ? () {
                                      showDeleteDetailLaporanDialog(
                                          context, detail.id);
                                    }
                                  : null,
                            ),
                          );
                        });
                  }))
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: () => _showTambahEditPerkembangan(context, null),
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
      child: Text("Catatan:....",
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500)),
    );
  }
}
