import 'package:flutter/material.dart';
import "package:littlesteps/pages/Guru/berandaGuruPage.dart";
import "package:littlesteps/pages/Guru/galeriGuruPage.dart";
import "package:littlesteps/pages/bantuan_page.dart";
import "package:littlesteps/pages/editprofile_page.dart";
import "package:littlesteps/pages/pesan_page.dart";
import "package:littlesteps/utils/auth_service.dart";
import "package:littlesteps/widgets/bottomNavbar.dart";
import "package:littlesteps/widgets/customappbar.dart";
import "package:littlesteps/widgets/customdrawer.dart";

class HomepageGuru extends StatefulWidget {
  final String role;
  const HomepageGuru({super.key, required this.role});

  @override
  State<HomepageGuru> createState() => _nameState();
}

class _nameState extends State<HomepageGuru> {
  final authService = AuthService();
  List<Widget> pages = [BerandaGuru(), GaleriGuruPage(), PesanPage()];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Color(0xff53B1FD), Colors.white, 0.9),
      appBar: CustomAppbar(role: widget.role),
      drawer: CustomDrawer(namaUser: "Bu Rani", menuItems: [
        {
          'title': 'Profil',
          'onTap': () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfilePage()));
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
      ]),
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
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Semua perubahan yang belum\ndisimpan mungkin akan hilang",
                textAlign: TextAlign.center,
                style: TextStyle(
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
                            fontWeight: FontWeight.w800,
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
                            fontWeight: FontWeight.w800,
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
