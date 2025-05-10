import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/pages/Guru/KehadiranPage.dart';
import 'package:littlesteps/pages/Guru/koneksiSiswaPage.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';
import 'package:littlesteps/pages/ProfilSiswa/profilsiswa_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BerandaGuru extends StatefulWidget {
  final String role;
  final String kelasId;
  const BerandaGuru({super.key, required this.kelasId, required this.role});

  @override
  State<BerandaGuru> createState() => _BerandaGuruState();
}

class _BerandaGuruState extends State<BerandaGuru> {
  List<Anak> daftarSiswa = [];
  File? selectedImage;

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

  Future<void> pickImage(Function setModalState) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      setModalState(() {});
    }
  }

  Future<List<String>> _uploadAllImages() async {
    if (selectedImage == null) return [];

    final List<String> uploadedUrls = [];

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'images/$fileName.jpg';

    final response = await Supabase.instance.client.storage
        .from('anak')
        .upload(path, selectedImage!);

    if (response.isEmpty) {
      throw Exception("Upload failed");
    }

    final publicUrl =
        Supabase.instance.client.storage.from('anak').getPublicUrl(path);

    uploadedUrls.add(publicUrl);

    return uploadedUrls;
  }

  Widget _buildSiswaItem(Anak siswa) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilSiswaPage(
              siswa: siswa,
              role: widget.role,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: siswa.fotoPath.startsWith('http')
                      ? NetworkImage(siswa.fotoPath) as ImageProvider
                      : FileImage(File(siswa.fotoPath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              siswa.namaPanggilan,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 700)],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTambahSiswaForm(BuildContext context) {
    String namaBaru = '';
    String panggilan = '';
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
                      'Buat Profil Siswa',
                      style: TextStyle(
                          fontVariations: [FontVariation('wght', 800)],
                          fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tulis nama lengkap siswa disini...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => namaBaru = val,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tulis nama panggilan siswa disini...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => panggilan = val,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => pickImage(setModalState),
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
                          if (namaBaru.isNotEmpty && panggilan.isNotEmpty) {
                            try {
                              final idSiswa =
                                  '${namaBaru.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
                              List<String> uploadedUrls =
                                  await _uploadAllImages();
                              String imageUrl = uploadedUrls.isNotEmpty
                                  ? uploadedUrls.first
                                  : '';
                              final siswaCollection = FirebaseFirestore.instance
                                  .collection('kelas')
                                  .doc(widget.kelasId)
                                  .collection('anak');

                              await siswaCollection.doc(idSiswa).set({
                                'id': idSiswa,
                                'nama': namaBaru,
                                'namaPanggilan': panggilan,
                                'fotoPath': imageUrl,
                                'idKelas': widget.kelasId,
                              });

                              setState(() {
                                selectedImage = null;
                                ambilDataSiswa();
                              });

                              Navigator.pop(context);
                            } catch (e) {
                              print("Gagal menyimpan data siswa: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Gagal menyimpan data siswa")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Nama lengkap dan panggilan wajib diisi")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Buat profil siswa',
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
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return SafeArea(
      child: Scaffold(
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
                child: daftarSiswa.isEmpty
                    ? const Center(child: Text("Belum ada siswa"))
                    : GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                        children: daftarSiswa
                            .map((siswa) => _buildSiswaItem(siswa))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          onPressed: () => showTambahSiswaForm(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
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
}
