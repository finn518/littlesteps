import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../model/anak.dart';

class KoneksiSiswaPage extends StatefulWidget {
  final String kelasId;
  const KoneksiSiswaPage({super.key, required this.kelasId});

  @override
  _KoneksiSiswaPageState createState() => _KoneksiSiswaPageState();
}

class _KoneksiSiswaPageState extends State<KoneksiSiswaPage> {
  ScrollController _scrollController = ScrollController();
  Map<String, String> kodeKelas = {};
  Map<String, DateTime> codeGeneratedTimes = {};

  String randomCode({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<void> _updateStudentSpecialCode(
      String kelasId, String studentId) async {
    final newCode = randomCode();
    final now = DateTime.now();

    await FirebaseFirestore.instance
        .collection('kelas')
        .doc(kelasId)
        .collection('anak')
        .doc(studentId)
        .update({
      'specialCode': newCode,
      'codeGeneratedAt': now,
    });

    setState(() {
      kodeKelas[studentId] = newCode;
      codeGeneratedTimes[studentId] = now;
    });
  }

  void _showHubungkanDialog(Anak siswa) async {
    DateTime now = DateTime.now();
    bool needNewCode = siswa.specialCode == null ||
        siswa.codeGeneratedAt == null ||
        now.difference(siswa.codeGeneratedAt!).inHours >= 3;

    if (needNewCode) {
      await _updateStudentSpecialCode(siswa.idKelas, siswa.id);
    }

    final doc = await FirebaseFirestore.instance
        .collection('kelas')
        .doc(siswa.idKelas)
        .collection('anak')
        .doc(siswa.id)
        .get();

    final updatedSiswa = Anak.fromMap(doc.data() as Map<String, dynamic>);
    final existingCode = updatedSiswa.specialCode;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kode Teks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (existingCode != null) {
                          Clipboard.setData(ClipboardData(text: existingCode));
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode telah disalin ke clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        existingCode ?? 'Kode tidak tersedia',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kode akan direset dalam ${3 - DateTime.now().difference(updatedSiswa.codeGeneratedAt ?? DateTime.now()).inHours} jam',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Instruksi Orang Tua',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Buka aplikasi Littlesteps\n'
                '2. Klik menu profil yang berada pada kiri atas halaman\n'
                '3. Klik "informasi anak"\n'
                '4. Masukkan kode di atas untuk bergabung ke kelas',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 36),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Koneksi Siswa",
          style: TextStyle(
            fontVariations: [FontVariation('wght', 800)],
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kelas')
            .doc(widget.kelasId) // Menggunakan widget.kelasId
            .collection('anak')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final siswaList = snapshot.data!.docs.map((doc) {
            return Anak.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          final jumlahTidakTerhubung =
              siswaList.where((siswa) => !siswa.isConnected).length;
          final jumlahTerhubung =
              siswaList.where((siswa) => siswa.isConnected).length;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        'TIDAK TERHUBUNG ($jumlahTidakTerhubung)',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...siswaList
                        .where((siswa) => !siswa.isConnected)
                        .map((siswa) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: siswa.fotoPath.startsWith('http')
                                      ? NetworkImage(siswa.fotoPath)
                                          as ImageProvider
                                      : FileImage(File(siswa.fotoPath)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tidak ada orang tua yang terhubung dengan ${siswa.namaPanggilan}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontVariations: [
                                          FontVariation('wght', 500)
                                        ]),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _showHubungkanDialog(siswa);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      side: const BorderSide(
                                          color: Colors.grey, width: 1),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.add,
                                        color: Colors.black, size: 18),
                                    label: const Text(
                                      'Hubungkan Orang Tua',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff3C4257),
                                          fontVariations: [
                                            FontVariation('wght', 600)
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        'SUDAH TERHUBUNG ($jumlahTerhubung)',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...siswaList
                        .where((siswa) => siswa.isConnected)
                        .map((siswa) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: siswa.fotoPath.startsWith('http')
                                      ? NetworkImage(siswa.fotoPath)
                                          as ImageProvider
                                      : FileImage(File(siswa.fotoPath)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Orang Tua ${siswa.namaPanggilan}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontVariations: [
                                          FontVariation('wght', 500)
                                        ]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${siswa.parentName}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xffA5ACB8),
                                        fontVariations: [
                                          FontVariation('wght', 600)
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
