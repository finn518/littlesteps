import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/rangkumanPenilaian.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/berandaGuruPage.dart';

class AddRangkumanPenilaianPage extends StatefulWidget {
  final String kelasId;
  final RangkumanPenilaian? rangkuman;

  const AddRangkumanPenilaianPage(
      {Key? key, required this.kelasId, this.rangkuman})
      : super(key: key);

  @override
  State<AddRangkumanPenilaianPage> createState() =>
      _AddRangkumanPenilaianPageState();
}

class _AddRangkumanPenilaianPageState extends State<AddRangkumanPenilaianPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController catatan = TextEditingController();

  String? selectedAnak;
  String? selectedSemester;
  String? selectedKompetensiDasar;
  String? selectedSubBab;
  String? selectedPoin;
  String? selectedNilai;

  List<Map<String, String>> siswaList = [];
  bool isLoadingAnak = true;
  bool catatanWajib = true;

  final List<String> semesterList = [
    'Semester 1 / 2024',
    'Semester 2 / 2025',
    'Semester 1 / 2025',
    'Semester 2 / 2026'
  ];
  final List<String> nilaiList = [
    'Belum Muncul',
    'Mulai Muncul',
    'Berkembang Sesuai Harapan',
    'Berkembang Sangat Baik'
  ];

  final Map<String, Map<String, List<String>>> kompetensiDasar = {
    'Nilai Agama dan Moral': {
      'Berdoa sebelum dan sesudah melaksanakan kegiatan': ['-'],
      'Menyanyikan lagu-lagu keagamaan': ['-'],
      'Meniru pelaksanaan kegiatan ibadah secara sederhana': ['-'],
      'Terlibat dalam kegiatan keagamaan': ['-'],
      'Membedakan ciptaan-ciptaan Tuhan': ['-'],
      'Membiasakan memberi dan menjawab salam': ['-'],
      'Menghafal Doa sehari-hari': [
        '-',
        'Doa sebelum makan',
        'Doa sesudah makan',
        'Doa sebelum tidur',
        'Doa bangun tidur',
        'Doa untuk kedua orang tua',
      ],
      'Menghafal Hadist': [
        '-',
        'Hadist kebersihan',
        'Hadist tidak boleh marah-marah',
      ],
      'Menghafal surat-surat pendek': [
        '-',
        'Surat Al-Ikhlas',
        'Surat An-Nas',
      ],
      'Mengikuti gerakan berwudhu dan sholat': ['-'],
      'Menirukan bacaan sholat': ['-']
    },
    'Sosial dan Emosional': {
      'Membedakan perilaku yang benar-salah dan baik-buruk': ['-'],
      'Bersosialisasi dan bermain bersama teman': ['-'],
      'Menghormati orang tua dan menyayangi teman': ['-'],
      'Berani bertanya secara sederhana': ['-'],
      'Melaksanakan kegiatan sendiri sampai selesai': ['-'],
      'Bertanggung jawab atas barang milik pribadinya': ['-'],
      'Berbagi dengan teman, menolong teman, sabar menunggu antrian': ['-']
    },
    'Fisik Motorik Kasar': {
      'Berjalan diatas papan titian': ['-'],
      'Memantulkan bola sambil berjalan/bergerak': ['-'],
      'Melempar dan menangkap bola': ['-'],
      'Berjalan dengan satu kaki': ['-'],
      'Melompat ke depan dan ke belakang': ['-'],
      'Mengikuti gerakan senam': ['-'],
    },
    'Fisik Motorik Halus': {
      'Life skill: memakai kaos kaki, memakai sepatu, melipat selimut, melipat alat sholat, sikat gigi, membuat susu':
          ['-'],
      'Meniru melipat kertas sederhana (4 lipatan)': ['-'],
      'Mewarnai sesuai dengan perintah maupun bebas': ['-'],
      'Merobek kertas, menempel kertas, menarik garis, finger painting secara mandiri':
          ['-'],
    },
    'Bahasa': {
      'Membedakan dan menirukan kembali bunyi/suara': ['-'],
      'Bercerita sederhana tentang pengalaman pribadi': ['-'],
      'Mengutarakan pendapat atau keinginannya': ['-'],
      'Mendengarkan dan menceritakan kembali isi cerita': ['-'],
      'Memahami perintah dan menjawab pertanyaan': ['-'],
    },
    'Kognitif': {
      'Mengelompokkan benda dengan berbagai cara menurut ciri-ciri tertentu. Misal: menurut warna, bentuk, ukuran, jenis, dll':
          ['-'],
      'Memasangkan benda sesuai dengan pasangannya, jenisnya, persamaannya, dll':
          ['-'],
      'Mengenal kasar-halus, berat-ringan, banyak-sedikit dan sama-tidak sama':
          ['-'],
      'Mengenal dan menghafal angka 1-5': ['-'],
    },
    'Seni': {
      'Menggambar bebas dengan berbagai media dengan rapi': ['-'],
      'Mewarnai bentuk gambar sederhana dengan rapi': ['-'],
      'Meronce dengan berbagai bentuk': ['-'],
      'Melukin dengan jari (Finger Painting)': ['-'],
      'Melukis dengan cetakan (Stamping)': ['-'],
      'Menciptakan bentuk bangunan dari balok': ['-'],
    }
  };

  List<String> getSubBabList() {
    return selectedKompetensiDasar != null
        ? kompetensiDasar[selectedKompetensiDasar!]!.keys.toList()
        : [];
  }

  List<String> getPoinList() {
    return (selectedKompetensiDasar != null && selectedSubBab != null)
        ? kompetensiDasar[selectedKompetensiDasar!]![selectedSubBab!]!
        : [];
  }

  @override
  void initState() {
    super.initState();
    fetchSiswa();

    if (widget.rangkuman != null) {
      selectedAnak = widget.rangkuman!.siswaId;
      selectedSemester = widget.rangkuman!.semester;
      selectedKompetensiDasar = widget.rangkuman!.kompetensiDasar;
      selectedSubBab = widget.rangkuman!.subBab.isNotEmpty
          ? widget.rangkuman!.subBab.first
          : null;
      selectedPoin = widget.rangkuman!.poinSubBab.isNotEmpty
          ? widget.rangkuman!.poinSubBab.first
          : null;
      selectedNilai = widget.rangkuman!.nilai.isNotEmpty
          ? widget.rangkuman!.nilai.first
          : null;
      catatan.text = widget.rangkuman!.catatan;
    }
  }

  Future<void> fetchSiswa() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('anak')
        .where('idKelas', isEqualTo: widget.kelasId)
        .get();

    final data = snapshot.docs.map((doc) {
      final nama = doc.data()['nama'] as String?;
      return {
        'id': doc.id,
        'nama': nama ?? 'Tanpa Nama',
      };
    }).toList();

    setState(() {
      siswaList = data;
    });
  }

  Widget buildDropdownRow({
    required String? value,
    required String label,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () async {
                // TModal
                final selectedItem = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Pilih Opsi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...items.map((item) {
                            return ListTile(
                              title: Text(
                                item,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, item);
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                );
                if (selectedItem != null) {
                  onChanged(selectedItem);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value ?? hint,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSiswaDropdownRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 5,
            child: Text(
              'Nama Anak :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: siswaList.isEmpty
                  ? null
                  : () async {
                      final selectedAnakBaru =
                          await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Pilih Nama Anak',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...siswaList.map((anak) {
                                  final namaAnak = anak['nama'] ?? 'Tanpa Nama';
                                  return ListTile(
                                    title: Text(
                                      namaAnak,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context, anak['id']);
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );

                      // Update nilai terpilih jika ada
                      if (selectedAnakBaru != null) {
                        setState(() => selectedAnak = selectedAnakBaru);
                        await cekStatusCatatan();
                      }
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: siswaList.isEmpty ? Colors.grey[200] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        siswaList.isEmpty
                            ? 'Memuat daftar siswa...'
                            : siswaList.firstWhere(
                                  (anak) => anak['id'] == selectedAnak,
                                  orElse: () => {'nama': 'Pilih siswa'},
                                )['nama'] ??
                                'Pilih siswa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: siswaList.isEmpty
                              ? Colors.black38
                              : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color:
                          siswaList.isEmpty ? Colors.black38 : Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveData({bool isEdit = false, String? docIdToEdit}) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('rangkumanPenilaian');

    if (_formKey.currentState!.validate()) {
      if (isEdit && docIdToEdit != null) {
        // ni buat edit semwa
        await collectionRef.doc(docIdToEdit).update({
          'siswaId': selectedAnak,
          'semester': selectedSemester,
          'kompetensiDasar': selectedKompetensiDasar,
          'subBab': [selectedSubBab],
          'poinSubBab': [selectedPoin],
          'nilai': [selectedNilai],
          'catatan': catatan.text,
        });
      } else {
        // ni kl kompetensi dasar sama y
        final querySnapshot = await collectionRef
            .where('siswaId', isEqualTo: selectedAnak)
            .where('semester', isEqualTo: selectedSemester)
            .where('kompetensiDasar', isEqualTo: selectedKompetensiDasar)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          List existingSubBab = List.from(doc.data()['subBab'] ?? []);
          List existingPoinSubBab = List.from(doc.data()['poinSubBab'] ?? []);
          List existingNilai = List.from(doc.data()['nilai'] ?? []);

          int index = existingSubBab.indexOf(selectedSubBab);
          if (index != -1) {
            existingPoinSubBab[index] = selectedPoin;
            existingNilai[index] = selectedNilai;
          } else {
            existingSubBab.add(selectedSubBab);
            existingPoinSubBab.add(selectedPoin);
            existingNilai.add(selectedNilai);
          }

          await doc.reference.update({
            'subBab': existingSubBab,
            'poinSubBab': existingPoinSubBab,
            'nilai': existingNilai,
          });
        } else {
          // Tambah baru ni
          final docRef = collectionRef.doc();
          await docRef.set({
            'id': docRef.id,
            'kelasId': widget.kelasId,
            'siswaId': selectedAnak,
            'semester': selectedSemester,
            'kompetensiDasar': selectedKompetensiDasar,
            'subBab': [selectedSubBab],
            'poinSubBab': [selectedPoin],
            'nilai': [selectedNilai],
            'catatan': catatan.text,
          });
        }
      }

      // Reset
      setState(() {
        selectedAnak = null;
        selectedSemester = null;
        selectedKompetensiDasar = null;
        selectedSubBab = null;
        selectedPoin = null;
        selectedNilai = null;
        catatan.clear();
        catatanWajib = false;
      });
    }
  }

  Widget buildCatatanField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: catatan,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tulis catatan Anda disini...',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFC0C0C0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
          validator: (val) {
            if (catatanWajib && (val == null || val.isEmpty)) {
              return 'Wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> cekStatusCatatan() async {
    if (selectedAnak != null &&
        selectedSemester != null &&
        selectedKompetensiDasar != null) {
      final collectionRef = FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.kelasId)
          .collection('rangkumanPenilaian');

      final querySnapshot = await collectionRef
          .where('siswaId', isEqualTo: selectedAnak)
          .where('semester', isEqualTo: selectedSemester)
          .where('kompetensiDasar', isEqualTo: selectedKompetensiDasar)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final existingCatatan = doc.data()['catatan'] ?? '';

        setState(() {
          catatanWajib = existingCatatan.isEmpty;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => KelasPage(role: "Guru")),
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Rangkuman Penilaian",
              style: TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: siswaList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          buildSiswaDropdownRow(context),
                          const SizedBox(height: 16),
                          buildDropdownRow(
                              value: selectedSemester,
                              label: "Semester: ",
                              hint: "Pilih Semester",
                              items: semesterList,
                              onChanged: (val) {
                                setState(() => selectedSemester = val);
                                cekStatusCatatan();
                              }),
                          const SizedBox(height: 16),
                          buildDropdownRow(
                              value: selectedKompetensiDasar,
                              label: "Kompetensi Dasar:",
                              hint: "Pilih KD",
                              items: kompetensiDasar.keys.toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedKompetensiDasar = val;
                                  selectedSubBab = null;
                                  selectedPoin = null;
                                });
                                cekStatusCatatan();
                              }),
                          const SizedBox(height: 16),
                          buildDropdownRow(
                            value: selectedSubBab,
                            label: "Sub Bab:",
                            hint: "Pilih Sub Bab",
                            items: getSubBabList(),
                            onChanged: (val) => setState(() {
                              selectedSubBab = val;
                              selectedPoin = null;
                            }),
                          ),
                          const SizedBox(height: 16),
                          buildDropdownRow(
                            value: selectedPoin,
                            label: "Poin Sub Bab:",
                            hint: "Pilih Poin",
                            items: getPoinList(),
                            onChanged: (val) =>
                                setState(() => selectedPoin = val),
                          ),
                          const SizedBox(height: 16),
                          buildDropdownRow(
                            value: selectedNilai,
                            label: "Nilai:",
                            hint: "Pilih Nilai",
                            items: nilaiList,
                            onChanged: (val) =>
                                setState(() => selectedNilai = val),
                          ),
                          const SizedBox(height: 16),
                          buildCatatanField(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => saveData(
                                isEdit: widget.rangkuman != null,
                                docIdToEdit: widget.rangkuman?.id),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text(
                              widget.rangkuman != null
                                  ? 'Simpan Perubahan'
                                  : 'Simpan Penilaian',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
