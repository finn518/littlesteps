import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/model/rangkumanPenilaian.dart';
import 'package:littlesteps/pages/ProfilSiswa/addRangkumanPenilaianPage.dart';
import 'package:littlesteps/pages/ProfilSiswa/detailpenilaian_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class RangkumanPerkembanganPage extends StatefulWidget {
  final String role;
  final Anak siswa;
  const RangkumanPerkembanganPage(
      {super.key, required this.role, required this.siswa});

  @override
  State<RangkumanPerkembanganPage> createState() =>
      _RangkumanPerkembanganPageState();
}

class _RangkumanPerkembanganPageState extends State<RangkumanPerkembanganPage> {
  String? selectedSemester;

  final List<String> urutanKompetensi = [
    'Nilai Agama dan Moral',
    'Sosial dan Emosional',
    'Fisik Motorik Kasar',
    'Fisik Motorik Halus',
    'Bahasa',
    'Kognitif',
    'Seni',
  ];

  Widget buildRangkumanList(List<RangkumanPenilaian> rangkumanList) {
    return Column(
      children: rangkumanList.asMap().entries.map((entry) {
        int index = entry.key + 1;
        RangkumanPenilaian rangkuman = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
              onTap: widget.role == 'Guru'
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddRangkumanPenilaianPage(
                                  kelasId: widget.siswa.idKelas,
                                  rangkuman: rangkuman)));
                    }
                  : null,
              child: CardCatatan(
                number: index,
                title: rangkuman.kompetensiDasar,
                onLongPress: widget.role == 'Guru'
                    ? () => showDeleteRangkumanPenilaianDialog(
                        context, rangkuman.id)
                    : null,
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Catatan: ${rangkuman.catatan}",
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPenilaianPage(
                                    role: widget.role,
                                    rangkuman: rangkuman,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Lihat Rincian",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }).toList(),
    );
  }

  void showDeleteRangkumanPenilaianDialog(
      BuildContext context, String idRangkumanPenilaian) {
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
                "Apakah Anda yakin ingin menghapus rangkuman penilaian?",
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
                      await deleteRangkumanPenilaian(idRangkumanPenilaian);
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

  Future<void> deleteRangkumanPenilaian(String idRangkumanPenilaian) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.siswa.idKelas)
          .collection('rangkumanPenilaian')
          .doc(idRangkumanPenilaian);
      await docRef.delete();
      setState(() {});

      debugPrint("Rangkuman Penilaian berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus Rangkuman Penilaian: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final isTeacher = widget.role == 'Guru';
    return Scaffold(
      backgroundColor: Color(0xFFEFF8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF8FA),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.075),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Rangkuman Penilaian",
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 800)],
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Pilihan Semester : ",
                  style: TextStyle(
                    fontSize: 16,
                    fontVariations: [FontVariation('wght', 600)],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints:
                      BoxConstraints(minWidth: width * 0.45, maxHeight: 30),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(
                        "Memilih Semester",
                        style: TextStyle(fontSize: 12),
                      ),
                      value: selectedSemester,
                      icon: Icon(Icons.arrow_drop_down),
                      items: [
                        DropdownMenuItem(
                          value: "Semester 1 / 2024",
                          child: Text("Semester 1 / 2024",
                              style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: "Semester 2 / 2025",
                          child: Text("Semester 2 / 2025",
                              style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: "Semester 1 / 2025",
                          child: Text("Semester 1 / 2025",
                              style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: "Semester 2 / 2026",
                          child: Text("Semester 2 / 2026",
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            if (selectedSemester != null)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('kelas')
                    .doc(widget.siswa.idKelas)
                    .collection('rangkumanPenilaian')
                    .where('semester', isEqualTo: selectedSemester)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Terjadi kesalahan saat mengambil data."));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text("Tidak ada data untuk semester ini."));
                  }
                  List<RangkumanPenilaian> rangkumanList =
                      snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return RangkumanPenilaian.fromMap({
                      'id': doc.id,
                      'kelasId': widget.siswa.idKelas,
                      'siswaId': widget.siswa.id,
                      'semester': selectedSemester!,
                      'kompetensiDasar': data['kompetensiDasar'] ?? '',
                      'subBab': data['subBab'] ?? [],
                      'poinSubBab': data['poinSubBab'] ?? [],
                      'nilai': data['nilai'] ?? [],
                      'catatan': data['catatan'] ?? 'Tidak ada catatan',
                    });
                  }).toList();
                  rangkumanList.sort((a, b) {
                    int indexA = urutanKompetensi.indexOf(a.kompetensiDasar);
                    int indexB = urutanKompetensi.indexOf(b.kompetensiDasar);
                    return indexA.compareTo(indexB);
                  });

                  return buildRangkumanList(rangkumanList);
                },
              ),
          ],
        ),
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddRangkumanPenilaianPage(
                        kelasId: widget.siswa.idKelas),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
              shape: const CircleBorder(),
            )
          : null,
    );
  }
}
