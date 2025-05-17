import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/model/catatankesehatan.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class CatatankesehatanPage extends StatefulWidget {
  final String role;
  final Anak siswa;
  const CatatankesehatanPage(
      {super.key, required this.role, required this.siswa});

  @override
  State<CatatankesehatanPage> createState() => _CatatankesehatanPageState();
}

class _CatatankesehatanPageState extends State<CatatankesehatanPage> {
  Future<void> _uploadUpdateCatatanKesehatan(CatatanKesehatan catatan) async {
    try {
      final siswa = widget.siswa;
      final siswaId = siswa.id;
      final kelasId = siswa.idKelas;

      DocumentReference docRef;
      if (catatan.id!.isNotEmpty) {
        //update yak
        docRef = FirebaseFirestore.instance
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(siswaId)
            .collection('catatanKesehatan')
            .doc(catatan.id);
      } else {
        // ini yg upload baru
        docRef = FirebaseFirestore.instance
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(siswaId)
            .collection('catatanKesehatan')
            .doc();
      }

      await docRef.set({
        'id': docRef.id,
        'siswaId': siswaId,
        'lingkarKepala': catatan.lingkarKepala,
        'beratBadan': catatan.beratBadan,
        'tinggiBadan': catatan.tinggiBadan,
        'semester': catatan.semester,
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  void _showTambahEditCatatan(BuildContext context, CatatanKesehatan? catatan) {
    final judul = TextEditingController(text: catatan?.semester ?? '');
    final lingkar =
        TextEditingController(text: catatan?.lingkarKepala.toString() ?? '');
    final tinggi =
        TextEditingController(text: catatan?.tinggiBadan.toString() ?? '');
    final berat =
        TextEditingController(text: catatan?.beratBadan.toString() ?? '');
    final isEdit = catatan != null;

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
                        ? 'Edit Catatan Kesehatan'
                        : 'Buat Catatan Kesehatan',
                    style: TextStyle(
                        fontSize: 24,
                        fontVariations: [FontVariation('wght', 800)]),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(judul, 'Tulis judul semester disini...', ''),
                  const SizedBox(height: 20),
                  _buildTextField(
                      lingkar, 'Tulis lingkaran kepala disini...', 'cm'),
                  const SizedBox(height: 20),
                  _buildTextField(tinggi, 'Tulis tinggi badan disini...', 'cm'),
                  const SizedBox(height: 20),
                  _buildTextField(berat, 'Tulis berat badan disini...', 'kg'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validasi sederhana (misal semua harus diisi)
                        if (judul.text.isEmpty ||
                            lingkar.text.isEmpty ||
                            tinggi.text.isEmpty ||
                            berat.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Semua field harus diisi')),
                          );
                          return;
                        }

                        // CatatanKesehatan baru/update
                        final newCatatan = CatatanKesehatan(
                          id: catatan?.id ?? '',
                          siswaId: widget.siswa.id,
                          semester: judul.text,
                          lingkarKepala: double.tryParse(lingkar.text) ?? 0,
                          tinggiBadan: double.tryParse(tinggi.text) ?? 0,
                          beratBadan: double.tryParse(berat.text) ?? 0,
                        );

                        await _uploadUpdateCatatanKesehatan(newCatatan);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isEdit
                            ? 'Edit Catatan Kesehatan'
                            : 'Buat Catatan Kesehatan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
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

  Widget _buildTextField(
      TextEditingController controller, String hint, String suffix) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          suffixText: suffix.isNotEmpty ? suffix : null,
          suffixStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.5,
              fontFamily: 'Poppins'),
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

  void showDeleteCatatanDialog(BuildContext context, String idCatatan) {
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
                "Apakah Anda yakin ingin menghapus catatan kesehatan ini?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Catatan kesehatan akan dihapus secara permanen.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 500)],
                  fontSize: 18,
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
                      await deleteCatatan(idCatatan);
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

  Future<void> deleteCatatan(String idCatatan) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.siswa.idKelas)
          .collection('anak')
          .doc(widget.siswa.id)
          .collection('catatanKesehatan')
          .doc(idCatatan);
      await docRef.delete();
      setState(() {});

      debugPrint("Catatan Kesehatan berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus Catatan Kesehatan: $e");
    }
  }

  int extractSemesterNumber(String semester) {
    final regex = RegExp(r'\d+'); // ambil angka berurutan dalam string
    final match = regex.firstMatch(semester);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final isTeacher = widget.role == 'Guru';
    final siswa = widget.siswa;
    final siswaId = siswa.id;
    final kelasId = siswa.idKelas;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 36,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Catatan Kesehatan",
              style: TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('kelas')
                  .doc(kelasId)
                  .collection('anak')
                  .doc(siswaId)
                  .collection('catatanKesehatan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final catatanList = snapshot.data?.docs ?? [];
                catatanList.sort((a, b) {
                  final aSem = extractSemesterNumber(a['semester'].toString());
                  final bSem = extractSemesterNumber(b['semester'].toString());
                  return aSem.compareTo(bSem);
                });
                if (catatanList.isEmpty) {
                  return const Center(
                    child: Text('Belum ada catatan kesehatan'),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.075),
                  itemCount: catatanList.length,
                  itemBuilder: (context, index) {
                    final data =
                        catatanList[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CardCatatan(
                        number: index + 1,
                        title: data['semester'],
                        body: content(data),
                        onTap: isTeacher
                            ? () {
                                final catatan = CatatanKesehatan(
                                  id: data['id'],
                                  siswaId: siswaId,
                                  semester: data['semester'],
                                  lingkarKepala: data['lingkarKepala'],
                                  tinggiBadan: data['tinggiBadan'],
                                  beratBadan: data['beratBadan'],
                                );
                                _showTambahEditCatatan(context, catatan);
                              }
                            : null,
                        onLongPress: isTeacher
                            ? () {
                                showDeleteCatatanDialog(context, data['id']);
                              }
                            : null,
                      ),
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
              onPressed: () => _showTambahEditCatatan(context, null),
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget content(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lingkaran Kepala : ${data['lingkarKepala']} cm",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          Text("Tinggi Badan : ${data['tinggiBadan']} cm",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          Text("Berat Badan : ${data['beratBadan']} kg",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
