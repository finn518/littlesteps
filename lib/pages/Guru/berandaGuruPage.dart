import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlesteps/model/kelas.dart';
import 'package:littlesteps/pages/Guru/KehadiranPage.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/koneksiSiswaPage.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BerandaGuru extends StatefulWidget {
  final String role;
  const BerandaGuru({super.key, required this.role});

  @override
  State<BerandaGuru> createState() => _BerandaGuruState();
}

class _BerandaGuruState extends State<BerandaGuru> {
  List<Kelas> daftarKelas = [];
  File? selectedImage;

  final FirebaseDatabase db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://littlesteps-52095-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  @override
  void initState() {
    super.initState();
    ambilDataKelas();
  }

  Future<void> ambilDataKelas() async {
    final dbRef = db.ref('kelas');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final kelasList = data.entries.map((e) {
        return Kelas.fromMap(Map<String, dynamic>.from(e.value));
      }).toList();

      setState(() {
        daftarKelas = kelasList;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImage = File(picked.path);
  }

  Future<List<String>> _uploadAllImages() async {
    if (selectedImage == null) return [];

    final List<String> uploadedUrls = [];

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'images/$fileName.jpg';

    final response = await Supabase.instance.client.storage
        .from('kelas')
        .upload(path, selectedImage!);

    final publicUrl =
        Supabase.instance.client.storage.from('kelas').getPublicUrl(path);

    uploadedUrls.add(publicUrl);

    return uploadedUrls;
  }

  void showTambahKelasForm(BuildContext context) {
    String namaKelas = '';
    String tahunAjaran = '';
    selectedImage = null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tambah Kelas Baru',
                    style: TextStyle(
                      fontVariations: [FontVariation('wght', 800)],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nama kelas...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => namaKelas = val,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tahun ajaran...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => tahunAjaran = val,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      await pickImage();
                      setModalState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: selectedImage == null
                            ? const Icon(Icons.image,
                                size: 50, color: Colors.grey)
                            : Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (namaKelas.isNotEmpty &&
                            tahunAjaran.isNotEmpty &&
                            selectedImage != null) {
                          try {
                            final urls = await _uploadAllImages();
                            final publicUrl = urls.first;
                            final idKelas =
                                namaKelas.toLowerCase().replaceAll(' ', '_');

                            await db.ref('kelas/$idKelas').set({
                              'id': idKelas,
                              'nama': namaKelas,
                              'tahunAjaran': tahunAjaran,
                              'gambarKelas': publicUrl,
                            });

                            selectedImage = null;
                            ambilDataKelas();
                            Navigator.pop(context);
                          } catch (e) {
                            print('Upload gagal: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Tambah Kelas',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          onPressed: () => showTambahKelasForm(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.01),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: _menuButton("assets/icons/guru_kalender.png",
                          'Calender', Color(0xFF8ED8FA), JadwalHarianPage())),
                  Expanded(
                      child: _menuButton("assets/icons/guru_kehadiran.png",
                          'Kehadiran', Color(0xFFFDE272), KehadiranPage())),
                  Expanded(
                      child: _menuButton(
                          "assets/icons/guru_koneksi_siswa.png",
                          'Koneksi Siswa',
                          Color(0xFFFF9C66),
                          koneksiSiswaPage())),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: daftarKelas.isEmpty
                    ? const Center(child: Text("Belum ada kelas."))
                    : ListView.builder(
                        itemCount: daftarKelas.length,
                        itemBuilder: (context, index) {
                          final kelas = daftarKelas[index];
                          return _classCard(
                            kelas.nama,
                            kelas.gambarKelas,
                            getBackgroundColor(kelas.nama),
                            KelasPage(
                              namaKelas: kelas.nama,
                              listSiswa: const [],
                              role: widget.role,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(String namaKelas) {
    switch (namaKelas) {
      case 'Kelas A':
        return Colors.blue[100]!;
      case 'Kelas B':
        return Colors.yellow[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Widget _menuButton(
      String imagePath, String label, Color color, Widget halaman) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => halaman),
            );
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: Offset(0, 5))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    height: 28,
                    width: 28,
                  ),
                  SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontVariations: [FontVariation('wght', 700)],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  Widget _classCard(
      String name, String imagePath, Color bgColor, Widget halaman) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => halaman),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150, // bisa disesuaikan
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontVariations: [FontVariation('wght', 800)],
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
}
