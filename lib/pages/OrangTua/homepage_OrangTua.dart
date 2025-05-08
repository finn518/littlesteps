import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:littlesteps/pages/OrangTua/beranda.dart";
import "package:littlesteps/pages/OrangTua/galeri_page.dart";
import "package:littlesteps/pages/OrangTua/keyanak_page.dart";
import "package:littlesteps/pages/bantuan_page.dart";
import "package:littlesteps/pages/editprofile_page.dart";
import "package:littlesteps/pages/login_page.dart";
import "package:littlesteps/pages/pesan_page.dart";
import "package:littlesteps/utils/auth_service.dart";
import "package:littlesteps/widgets/bottomNavbar.dart";
import "package:littlesteps/widgets/customappbar.dart";
import "package:littlesteps/widgets/customdrawer.dart";

class HomePageOrangTua extends StatefulWidget {
  final String role;
  const HomePageOrangTua({super.key, required this.role});
  
  @override
  State<HomePageOrangTua> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageOrangTua> {
  final authService = AuthService();
  User? _user;
  String namaUser = "pengguna";
  List<Widget> pages = [Beranda(), GaleriPage(), PesanPage()];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout() async {
    await authService.signOut();
    if (!context.mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(role: widget.role),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
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
        setState(() {
          namaUser = data['name'] ?? 'Pengguna';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        role: widget.role,
      ),
      drawer: CustomDrawer(
        namaUser: namaUser,
        menuItems: [
          {
            'title': 'Profil',
            'onTap': () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            role: widget.role,
                          )));
            }
          },
          {
            'title': 'Informasi Anak',
            'onTap': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KeyAnakPage(
                            role: widget.role,
                          )));
            }
          },
          {
            'title': 'Bantuan',
            'onTap': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BantuanPage()));
            }
          },
          {
            'title': 'Keluar Akun',
            'onTap': () => showLogoutDialog(context),
          },
        ],
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
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
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda yakin\ningin keluar akun?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
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
                  // Tombol Ya
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xff0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // tutup dialog
                      // Aksi logout
                      logout();
                    },
                    child: Text("Ya",
                        style: TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Colors.white,
                            fontSize: 18)),
                  ),
                  SizedBox(width: 16),
                  // Tombol Tidak
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Tidak",
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
}
