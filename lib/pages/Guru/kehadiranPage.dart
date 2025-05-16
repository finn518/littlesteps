import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/model/kehadiran.dart';

class KehadiranPage extends StatefulWidget {
  final String kelasId;
  const KehadiranPage({super.key, required this.kelasId});

  @override
  _KehadiranPageState createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  List<Anak> daftarSiswa = [];
  Map<String, String> absensi = {};
  DateTime tanggalRangkuman = DateTime.now();
  bool isAbsensi = true;

  @override
  void initState() {
    super.initState();
    ambilDataSiswa();
  }

  Future<void> ambilDataSiswa() async {
    final siswaList = FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('anak');
    final snapshot = await siswaList.get();

    setState(() {
      daftarSiswa = snapshot.docs.map((doc) {
        return Anak.fromMap(doc.data());
      }).toList();
    });
  }

  Widget _buildSiswaTile(Anak siswa) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Color(0xFFD1E9FF)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: siswa.fotoPath.isNotEmpty
                  ? DecorationImage(
                      image: siswa.fotoPath.startsWith('http')
                          ? NetworkImage(siswa.fotoPath)
                          : FileImage(File(siswa.fotoPath)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage('assets/images/kid_face.png'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(
            siswa.namaPanggilan,
            style: TextStyle(fontVariations: [FontVariation('wght', 600)]),
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            child: DropdownButtonHideUnderline(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  hint: Text(
                    'Pilihan Absensi',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  value: absensi[siswa.id],
                  icon: Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(12),
                  items: ['Hadir', 'Izin', 'Sakit', 'Absen']
                      .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: TextStyle(fontFamily: 'Poppins'),
                          )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      absensi[siswa.id] = value!;
                    });
                  }),
            )),
          )
        ],
      ),
    );
  }

  Future<String> ambilNamaKelas(String kelasId) async {
    final doc =
        await FirebaseFirestore.instance.collection('kelas').doc(kelasId).get();
    if (doc.exists) {
      return doc.data()?['nama'] ?? 'Tanpa Nama';
    } else {
      return 'Kelas Tidak Ditemukan';
    }
  }

  void showSuccessPopup(
      BuildContext context, String namaKelas, String tanggal) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/success.png', height: 75),
                    const SizedBox(height: 16),
                    Text(
                      'Kehadiran Kelas $namaKelas\ntanggal $tanggal\nberhasil disimpan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontVariations: [FontVariation('wght', 700)]),
                    )
                  ],
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 24),
                    ))
              ],
            ),
          );
        });
  }

  int tentukanSemester(DateTime tanggal, int tahunAngkatan) {
    final tahun = tanggal.year;
    final bulan = tanggal.month;

    if (tahun == tahunAngkatan && bulan >= 7 && bulan <= 12) {
      return 1;
    } else if (tahun == tahunAngkatan + 1 && bulan >= 1 && bulan <= 6) {
      return 2;
    } else if (tahun == tahunAngkatan + 1 && bulan >= 7 && bulan <= 12) {
      return 3;
    } else if (tahun == tahunAngkatan + 2 && bulan >= 1 && bulan <= 6) {
      return 4;
    } else {
      return 0;
    }
  }

  Future<Map<String, int>> ambilRangkumanKehadiran(DateTime tanggal) async {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);
    final snapshot = await FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('kehadiran')
        .where('tanggal', isEqualTo: formattedDate)
        .get();

    final rangkuman = {
      'Hadir': 0,
      'Izin': 0,
      'Sakit': 0,
      'Absen': 0,
    };

    for (var doc in snapshot.docs) {
      final status = doc.data()['status'] as String?;
      if (status != null && rangkuman.containsKey(status)) {
        rangkuman[status] = rangkuman[status]! + 1;
      }
    }

    return rangkuman;
  }

  Widget _buildRangkumanCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    tanggalRangkuman =
                        tanggalRangkuman.subtract(const Duration(days: 1));
                  });
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'id_ID').format(tanggalRangkuman),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    tanggalRangkuman =
                        tanggalRangkuman.add(const Duration(days: 1));
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 8),

          //Tabel rekap kehadirannya
          FutureBuilder<Map<String, int>>(
              future: ambilRangkumanKehadiran(tanggalRangkuman),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text("Gagal memuat data kehadiran");
                }

                final rangkuman = snapshot.data ?? {};

                //Ini buat itung persentase kehadinnya
                final totalSiswa =
                    rangkuman.values.fold(0, (sum, count) => sum + count);
                final totalHadir = rangkuman['Hadir'] ?? 0;
                final persentaseHadir = totalSiswa > 0
                    ? (totalHadir / totalSiswa * 100).toInt()
                    : 0;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //  judul pake background biru
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF84CAFF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Rekap Kehadiran: $persentaseHadir%",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontVariations: [FontVariation('wght', 800)],
                          ),
                        ),
                      ),
                      // Tabel tanpa background (transparan)
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        border: TableBorder.symmetric(
                          inside:
                              const BorderSide(color: Colors.white, width: 1),
                        ),
                        children: [
                          TableRow(
                            children: [
                              _buildStatusCell(
                                  "Hadir", rangkuman['Hadir'] ?? 0, 0, 0),
                              _buildStatusCell(
                                  "Izin", rangkuman['Izin'] ?? 0, 0, 1),
                            ],
                          ),
                          TableRow(
                            children: [
                              // Radius buat kiri
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: _buildStatusCell(
                                    "Sakit", rangkuman['Sakit'] ?? 0, 1, 0),
                              ),

                              // Radisu kanan
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                ),
                                child: _buildStatusCell(
                                    "Alpha", rangkuman['Absen'] ?? 0, 1, 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget _buildStatusCell(String status, int count, int row, int col) {
    final warnaLatar = (row + col) % 2 == 0
        ? const Color(0xFFB2DDFF)
        : const Color(0xFFEFF8FF);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: warnaLatar,
      child: Text(
        "$status : $count",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontVariations: [FontVariation('wght', 800)]),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAbsensi ? Color(0xFF8ED8FA) : Colors.white,
                  foregroundColor: isAbsensi ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.black),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                onPressed: () {
                  setState(() {
                    isAbsensi = true;
                  });
                },
                child: const Text(
                  'Absensi',
                  style: TextStyle(
                      color: Colors.black,
                      fontVariations: [FontVariation('wght', 800)]),
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAbsensi ? Colors.white : Color(0xFF8ED8FA),
                    foregroundColor: isAbsensi ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  onPressed: () {
                    setState(() {
                      isAbsensi = false;
                    });
                  },
                  child: const Text(
                    "Rangkuman",
                    style: TextStyle(
                        color: Colors.black,
                        fontVariations: [FontVariation('wght', 800)]),
                  )))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 36)),
          title: Text("Kehadiran",
              style: TextStyle(
                  color: Colors.black,
                  fontVariations: [FontVariation('wght', 800)],
                  fontSize: 24)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            _buildToggleButtons(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            if (isAbsensi)
              Text(DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                  style: TextStyle(color: Colors.black)),
            isAbsensi
                ? Expanded(
                    child: ListView.builder(
                      itemCount: daftarSiswa.length,
                      itemBuilder: (context, index) {
                        final siswa = daftarSiswa[index];
                        return _buildSiswaTile(siswa);
                      },
                    ),
                  )
                : SingleChildScrollView(
                    child: _buildRangkumanCard(),
                  ),
            if (isAbsensi)
              SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        final kelasSnapshot = await FirebaseFirestore.instance
                            .collection('kelas')
                            .doc(widget.kelasId)
                            .get();

                        final kelasData = kelasSnapshot.data()!;
                        final tahunAngkatan =
                            int.parse(kelasData['tahunAngkatan']);
                        final now = DateTime.now();
                        final semester = tentukanSemester(now, tahunAngkatan);
                        final formattedDate =
                            DateFormat('dd MMMM yyyy', 'id_ID').format(now);
                        final firestore = FirebaseFirestore.instance;

                        for (final siswa in daftarSiswa) {
                          final status = absensi[siswa.id] ?? 'Absen';

                          final existingQuery = await firestore
                              .collection('kelas')
                              .doc(widget.kelasId)
                              .collection('kehadiran')
                              .where('siswaId', isEqualTo: siswa.id)
                              .where('tanggal', isEqualTo: formattedDate)
                              .limit(1)
                              .get();

                          if (existingQuery.docs.isNotEmpty) {
                            final docId = existingQuery.docs.first.id;
                            await firestore
                                .collection('kelas')
                                .doc(widget.kelasId)
                                .collection('kehadiran')
                                .doc(docId)
                                .update({
                              'status': status,
                            });
                          } else {
                            final docRef = firestore
                                .collection('kelas')
                                .doc(widget.kelasId)
                                .collection('kehadiran')
                                .doc();
                            final kehadiran = Kehadiran(
                                id: docRef.id,
                                siswaId: siswa.id,
                                kelasId: widget.kelasId,
                                status: status,
                                tanggal: formattedDate,
                                semester: semester);

                            await docRef.set(kehadiran.toMap());
                          }
                        }
                        final namaKelas = await ambilNamaKelas(widget.kelasId);
                        final tanggalPopup =
                            DateFormat('dd MMMM yyyy', 'id_ID').format(now);
                        showSuccessPopup(context, namaKelas, tanggalPopup);
                        setState(() {
                          absensi.clear();
                        });
                      },
                      child: const Text(
                        'Simpan Kehadiran',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      )),
                ),
              ))
          ],
        ));
  }
}
