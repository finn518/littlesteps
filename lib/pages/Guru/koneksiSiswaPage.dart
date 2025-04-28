import 'dart:math';

import 'package:flutter/material.dart';

import 'siswa.dart';

class koneksiSiswaPage extends StatefulWidget {
  @override
  _KoneksiSiswaPageState createState() => _KoneksiSiswaPageState();
}

class _KoneksiSiswaPageState extends State<koneksiSiswaPage> {
  String? selectedKelas;
  ScrollController _scrollController = ScrollController();
  Map<String, String> kodeKelas = {};
  Map<String, DateTime> codeGeneratedTimes = {};

  List<Siswa> get currentSiswaList {
    if (selectedKelas == 'Kelas A') {
      return siswaKelasA;
    } else if (selectedKelas == 'Kelas B') {
      return siswaKelasB;
    } else {
      return [];
    }
  }

  String generateRandomCode(int length) {
    const chara = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chara.codeUnitAt(random.nextInt(chara.length)),
    ));
  }

  void _showHubungkanDialog(Siswa siswa) {
    DateTime now = DateTime.now();
    String? existingCode = kodeKelas[selectedKelas];
    DateTime? generatedAt = codeGeneratedTimes[selectedKelas];

    //Ini buat kalau kode belum ada atau udh lebih dari 3 jam bakal generate baru
    if (existingCode == null ||
        generatedAt == null ||
        now.difference(generatedAt).inHours >= 3) {
      String newCode = generateRandomCode(6);
      kodeKelas[selectedKelas!] = newCode;
      codeGeneratedTimes[selectedKelas!] = now;
      existingCode = newCode;
    }

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
            crossAxisAlignment:
                CrossAxisAlignment.start, // <-- supaya semua rata kiri
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
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      existingCode ?? '',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Demi alasan keamanan, kode akan direset dalam 3 jam kemudian',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Instruksi Orang Tua',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Buka aplikasi Littlesteps\n'
                '2. Klik menu profil yang berada pada kiri atas halaman\n'
                '3. Klik "informasi anak"\n'
                '4. Masukkan kode di atas untuk bergabung ke kelas',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int jumlahTidakTerhubung =
        currentSiswaList.where((siswa) => !siswa.isConnected).length;
    final int jumlahTerhubung =
        currentSiswaList.where((siswa) => siswa.isConnected).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Koneksi Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF53B1FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedKelas = 'Kelas A';
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      });
                    },
                    child: Text(
                      'Kelas A',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFDE272),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedKelas = 'Kelas B';
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      });
                    },
                    child: Text(
                      'Kelas B',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedKelas ?? 'Pilih Kelas',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          if (selectedKelas != null)
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                children: [
                  Text(
                    'TIDAK TERHUBUNG ($jumlahTidakTerhubung)',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ...currentSiswaList
                      .where((siswa) => !siswa.isConnected)
                      .map((siswa) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            siswa.imagePath,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tidak ada orang tua yang terhubung dengan ${siswa.name}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
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
                                    side: BorderSide(
                                        color: Colors.grey, width: 1),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  icon: Icon(Icons.add,
                                      color: Colors.black, size: 18),
                                  label: const Text(
                                    'Hubungkan Orang Tua',
                                    style: TextStyle(color: Colors.black),
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
                  Text(
                    'SUDAH TERHUBUNG ($jumlahTerhubung)',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ...currentSiswaList
                      .where((siswa) => siswa.isConnected)
                      .map((siswa) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Image.asset(
                            siswa.imagePath,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orang Tua ${siswa.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${siswa.parentName}',
                                  style: const TextStyle(color: Colors.black54),
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
      ),
    );
  }
}
