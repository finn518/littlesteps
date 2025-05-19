import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import "package:littlesteps/pages/bantuan_page.dart";
import "package:littlesteps/pages/editprofile_page.dart";
import "package:littlesteps/pages/login_page.dart";
import "package:littlesteps/utils/auth_service.dart";
import "package:littlesteps/widgets/customappbar.dart";
import "package:littlesteps/widgets/customdrawer.dart";
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/kelas.dart';

class KelasPage extends StatefulWidget {
  final String role;

  const KelasPage({super.key, required this.role});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  final authService = AuthService();
  fb_auth.User? _user;
  String namaUser = "Memuat...";
  List<Kelas> daftarKelas = [];
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    ambilDataKelas();
    _loadUserData();
  }

  void _loadUserData() async {
    _user = authService.currentUser;
    if (_user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      final data = doc.data();
      if (data != null) {
        final String sapaan = data['sapaan'] ?? '';
        final String name = data['name'] ?? '';
        setState(() {
          if (sapaan.isNotEmpty) {
            namaUser = '$sapaan $name';
          } else {
            namaUser = name.isNotEmpty ? name : 'Pengguna';
          }
        });
      }
    }
  }

  void logout() async {
    await authService.signOut();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(role: widget.role),
      ),
      (route) => false,
    );
  }

  void showLogoutDialog(BuildContext context) {
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
                "Apakah Anda yakin\ningin keluar akun?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Semua perubahan yang belum\ndisimpan mungkin akan hilang",
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
                    onPressed: () {
                      Navigator.pop(context); // tutup dialog
                      logout();
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
                    onPressed: () => Navigator.pop(context),
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

  Future<void> ambilDataKelas() async {
    final kelasList = FirebaseFirestore.instance.collection('kelas');
    final snapshot = await kelasList.get();

    setState(() {
      daftarKelas = snapshot.docs.map((doc) {
        return Kelas.fromMap(doc.data());
      }).toList();
    });
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

    await Supabase.instance.client.storage
        .from('kelas')
        .upload(path, selectedImage!);

    final publicUrl =
        Supabase.instance.client.storage.from('kelas').getPublicUrl(path);

    uploadedUrls.add(publicUrl);

    return uploadedUrls;
  }

  void showTambahEditKelasForm(BuildContext context, {Kelas? kelas}) {
    String namaKelas = kelas?.nama ?? '';
    String tahunAngkatan = kelas?.tahunAngkatan ?? '';
    selectedImage = null;

    final isEdit = kelas != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final TextEditingController namaController =
                TextEditingController(text: namaKelas);
            final TextEditingController tahunController =
                TextEditingController(text: tahunAngkatan);

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
                  Text(
                    isEdit ? 'Edit Kelas' : 'Buat Kelas',
                    style: TextStyle(
                      fontVariations: [FontVariation('wght', 800)],
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: 'Tulis nama kelas disini...',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontFamily: 'Poppins'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (val) => namaKelas = val,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tahunController,
                    decoration: InputDecoration(
                      hintText: 'Tulis tahun angkatan disini...',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontFamily: 'Poppins'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (val) => tahunAngkatan = val,
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
                        child: selectedImage != null
                            ? Image.file(selectedImage!, fit: BoxFit.cover)
                            : (isEdit && kelas!.fullImageUrl.isNotEmpty
                                ? Image.network(kelas.fullImageUrl,
                                    fit: BoxFit.cover)
                                : const Icon(Icons.image,
                                    size: 50, color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (namaKelas.isNotEmpty && tahunAngkatan.isNotEmpty) {
                          try {
                            final idKelas = isEdit
                                ? kelas!.id
                                : namaKelas.toLowerCase().replaceAll(' ', '_');

                            String namaFile = kelas?.gambarKelas ?? '';

                            if (selectedImage != null) {
                              final hasil = await _uploadAllImages();
                              namaFile = hasil.first;
                            }

                            final data = {
                              'id': idKelas,
                              'nama': namaKelas,
                              'tahunAngkatan': tahunAngkatan,
                              'gambarKelas': namaFile,
                            };

                            final docRef = FirebaseFirestore.instance
                                .collection('kelas')
                                .doc(idKelas);
                            final docSnapshot = await docRef.get();

                            if (docSnapshot.exists) {
                              await docRef.update(data);
                            } else {
                              await docRef.set(data);
                            }

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
                      child: Text(
                        isEdit ? 'Edit Kelas' : 'Buat Kelas',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontVariations: [FontVariation('wght', 800)],
                            fontFamily: 'Poppins'),
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

  Widget _classCard(
      Kelas kelas, Color bgColor, Widget halaman, BuildContext context) {
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        kelas.fullImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          showTambahEditKelasForm(context, kelas: kelas);
                        },
                        child: CircleAvatar(
                          radius: 22, // Lingkaran putih (luar)
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 16, // Lingkaran biru muda (dalam)
                            backgroundColor: Colors.blue[100],
                            child: ImageIcon(
                              AssetImage('assets/icons/edit.png'),
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kelas.nama,
                        style: const TextStyle(
                          fontSize: 20,
                          fontVariations: [FontVariation('wght', 800)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Angkatan ${kelas.tahunAngkatan}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontVariations: [FontVariation('wght', 800)],
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteClassDialog(BuildContext context, String idKelas) {
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
                "Apakah Anda yakin ingin menghapus kelas ini?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Data kelas akan dihapus secara permanen.",
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
                      await deleteClass(idKelas);
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

  Future<void> deleteClass(String idKelas) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('kelas').doc(idKelas);
      await docRef.delete();
      await ambilDataKelas();
      setState(() {});

      print("Kelas berhasil dihapus.");
    } catch (e) {
      print("Gagal menghapus kelas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(const Color(0xff53B1FD), Colors.white, 0.9),
      appBar: CustomAppbar(role: widget.role),
      drawer: CustomDrawer(namaUser: namaUser, menuItems: [
        {
          'title': 'Profil',
          'onTap': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(role: widget.role),
              ),
            );
          },
        },
        {
          'title': 'Bantuan',
          'onTap': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BantuanPage()),
            );
          },
        },
        {
          'title': 'Keluar Akun',
          'onTap': () => showLogoutDialog(context),
        },
      ]),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kelas',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontVariations: [FontVariation('wght', 800)],
                  fontSize: 32),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: daftarKelas.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: daftarKelas.length,
                      itemBuilder: (context, index) {
                        final kelas = daftarKelas[index];
                        final bgColor = index % 2 == 0
                            ? Colors.blue[100]!
                            : Colors.yellow[100]!;
                        return GestureDetector(
                          onLongPress: () {
                            showDeleteClassDialog(context, kelas.id);
                          },
                          child: _classCard(
                            kelas,
                            bgColor,
                            HomepageGuru(kelasId: kelas.id, role: widget.role),
                            context,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () => showTambahEditKelasForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
