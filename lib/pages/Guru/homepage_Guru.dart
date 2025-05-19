import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import "package:littlesteps/pages/Guru/berandaGuruPage.dart";
import "package:littlesteps/pages/Guru/galeriGuruPage.dart";
import "package:littlesteps/pages/ProfilSiswa/addRangkumanPenilaianPage.dart";
import "package:littlesteps/pages/bantuan_page.dart";
import "package:littlesteps/pages/editprofile_page.dart";
import "package:littlesteps/pages/login_page.dart";
import "package:littlesteps/pages/pesan_page.dart";
import "package:littlesteps/utils/auth_service.dart";
import "package:littlesteps/widgets/bottomNavbar.dart";
import "package:littlesteps/widgets/customappbar.dart";
import "package:littlesteps/widgets/customdrawer.dart";

class HomepageGuru extends StatefulWidget {
  final String role;
  final String kelasId;
  const HomepageGuru({super.key, required this.role, required this.kelasId});

  @override
  State<HomepageGuru> createState() => _HomepageGuruState();
}

class _HomepageGuruState extends State<HomepageGuru> {
  final authService = AuthService();
  User? _user;
  String namaUser = "Memuat...";
  late List<Widget> pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      BerandaGuru(kelasId: widget.kelasId, role: widget.role),
      GaleriGuruPage(kelasId: widget.kelasId),
      PesanPage(kelasId: widget.kelasId, role: widget.role),
    ];
    _loadUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          'title': 'Rangkuman Penilaian',
          'onTap': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddRangkumanPenilaianPage(kelasId: widget.kelasId),
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
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
