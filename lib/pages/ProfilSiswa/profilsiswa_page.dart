import 'dart:io';
import 'dart:ui';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:littlesteps/pages/Guru/KelasPage.dart";
import "package:littlesteps/pages/Guru/laporanPerkembanganGuruPage.dart";
import "package:littlesteps/pages/Guru/rangkumanKehadiran.dart";
import "package:littlesteps/model/anak.dart";
import "package:littlesteps/pages/OrangTua/homepage_OrangTua.dart";
import "package:littlesteps/pages/ProfilSiswa/catatankesehatan_page.dart";
import "package:littlesteps/pages/ProfilSiswa/rangkumanpenilaian_page.dart";
import "package:littlesteps/utils/auth_service.dart";
import "package:littlesteps/utils/device_dimension.dart";
import 'package:littlesteps/widgets/appBackground.dart';

class ProfilSiswaPage extends StatefulWidget {
  final Anak siswa;
  final String role;
  const ProfilSiswaPage({super.key, required this.siswa, required this.role});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {
  final authService = AuthService();
  User? _user;
  Anak? anak;

  Future<void> _disconnectChild() async {
    final firestore = FirebaseFirestore.instance;
    _user = authService.currentUser;
    if (_user == null) return;

    try {
      final userDoc = await firestore.collection('users').doc(_user!.uid).get();
      final userData = userDoc.data();
      if (userData == null) return;

      final String anakId = userData['anakId'] ?? '';
      final String kelasId = userData['kelasId'] ?? '';

      // Update data user terlebih dahulu
      await firestore.collection('users').doc(_user!.uid).update({
        'isConnected': false,
        'anakId': FieldValue.delete(),
        'namaAnak': FieldValue.delete(),
        'kelasId': FieldValue.delete(),
        'connectedAt': FieldValue.delete()
      });

      // Jika ada data anak, update juga di koleksi anak
      if (anakId.isNotEmpty && kelasId.isNotEmpty) {
        final anakRef = firestore
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(anakId);

        final anakDoc = await anakRef.get();
        if (anakDoc.exists) {
          await anakRef.update({
            'isConnected': false,
            'parentName': FieldValue.delete(),
            'parentId': FieldValue.delete(),
            'connectedAt': FieldValue.delete()
          });
        }
      }

      if (mounted) {
        setState(() {
          anak = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Koneksi dengan anak telah diputus."),
            duration: Duration(seconds: 2),
          ),
        );

        // Kembali ke halaman utama
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageOrangTua(role: widget.role),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print("Error disconnecting child: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memutus koneksi.")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (widget.role == "Guru") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KelasPage(role: widget.role)),
                  (route) => false,
                );
              } else if (widget.role == "Orang Tua") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePageOrangTua(role: widget.role)),
                  (route) => false,
                );
              }
            },
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 15),
            onPressed: () {},
            icon: const Icon(Icons.download_for_offline_outlined, size: 48),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: widget.siswa.fotoPath.startsWith('http')
                      ? NetworkImage(widget.siswa.fotoPath)
                      : FileImage(File(widget.siswa.fotoPath)) as ImageProvider,
                ),
                const SizedBox(height: 25),
                Text(
                  widget.siswa.nama,
                  style: const TextStyle(
                    fontSize: 32,
                    fontVariations: [FontVariation('wght', 800)],
                  ),
                ),
                const SizedBox(height: 30),
                buildMenuButton("Catatan Kesehatan", const Color(0xffB2DDFF),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CatatankesehatanPage(role: widget.role),
                    ),
                  );
                }),
                buildMenuButton("Laporan Perkembangan", const Color(0xffFDE272),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LaporanPerkembanganGuru(role: widget.role),
                    ),
                  );
                }),
                buildMenuButton("Rangkuman Penilaian", const Color(0xffFF9C66),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RangkumanPerkembanganPage(role: widget.role),
                    ),
                  );
                }),
                buildMenuButton("Rangkuman Kehadiran", const Color(0xffACDC79),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RangkumanKehadiran(),
                    ),
                  );
                }),

                // Tambahan sesuai role
                if (widget.role == 'Guru')
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 300)
                else ...[
                  GestureDetector(
                    onTap: () {
                      showDisconnectDialog(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 80),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontVariations: [FontVariation('wght', 800)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(String label, Color? color, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontVariations: [FontVariation('wght', 800)],
            ),
          ),
        ),
      ),
    );
  }

  void showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda yakin\ningin keluar profil anak?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Semua perubahan yang belum\ndisimpan mungkin akan hilang",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 500)],
                  color: Colors.grey[600],
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Ya dengan shadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xff0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _disconnectChild();
                      },
                      child: Text(
                        "Ya",
                        style: TextStyle(
                          fontVariations: [FontVariation('wght', 800)],
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Tombol Tidak tanpa shadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Tidak",
                        style: TextStyle(
                          fontVariations: [FontVariation('wght', 800)],
                          color: Color(0xff0066FF),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
