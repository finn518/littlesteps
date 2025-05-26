import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
// import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:littlesteps/model/anak.dart";
import "package:littlesteps/pages/OrangTua/beranda.dart";
import "package:littlesteps/pages/OrangTua/galeri_page.dart";
import "package:littlesteps/pages/OrangTua/keyanak_page.dart";
import "package:littlesteps/pages/ProfilSiswa/profilsiswa_page.dart";
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
  Anak? anak;
  String kelasId = "";
  String? fotoPath;
  late List<Widget> pages;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout() async {
    await authService.signOut();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(role: widget.role)),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    pages = [
      Beranda(),
      GaleriPage(),
      PesanPage(role: widget.role, kelasId: ""),
    ];
    _loadUserData();
    _checkConnected(); // Memastikan data anak dimuat
    // saveFCM();
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
          namaUser = sapaan.isNotEmpty
              ? '$sapaan $name'
              : (name.isNotEmpty ? name : 'Pengguna');
        });
      }
      if (doc.exists && doc.data()!.containsKey('fotoPath')) {
        final path = doc['fotoPath'];
        if (path != null && path != '') {
          setState(() {
            fotoPath = path;
          });
        }
      }
    }
  }

  Future<void> _checkConnected() async {
    final firestore = FirebaseFirestore.instance;
    _user = authService.currentUser;
    if (_user == null) return;

    try {
      final doc = await firestore.collection('users').doc(_user!.uid).get();
      final data = doc.data();
      if (data == null) return;

      final bool connected = data['isConnected'] ?? false;
      final String anakId = data['anakId'] ?? '';
      kelasId = data['kelasId'] ?? '';

      if (connected && anakId.isNotEmpty && kelasId.isNotEmpty) {
        final anakRef = firestore
            .collection('kelas')
            .doc(kelasId)
            .collection('anak')
            .doc(anakId);
        final anakDoc = await anakRef.get();

        if (anakDoc.exists) {
          final anakData = anakDoc.data();
          if (anakData != null) {
            setState(() {
              anak = Anak.fromMap(anakData);
              kelasId = data['kelasId'] ?? '';

              pages = [
                Beranda(),
                GaleriPage(),
                PesanPage(
                  role: widget.role,
                  kelasId: kelasId,
                )
              ];
            });
          }
        } else {
          setState(() {
            pages = [
              Beranda(),
              GaleriPage(),
              PesanPage(
                role: widget.role,
                kelasId: "", // kelasId kosong jika belum terhubung
              )
            ];
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data anak tidak ditemukan.")),
          );

          // Reset connection status jika data tidak ditemukan
          await _resetUserConnection();
        }
      }
    } catch (e) {
      print("Error checking connection: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memeriksa koneksi anak.")),
      );
    }
  }

  Future<void> _resetUserConnection() async {
    final firestore = FirebaseFirestore.instance;
    if (_user == null) return;

    await firestore.collection('users').doc(_user!.uid).update({
      'isConnected': false,
      'anakId': FieldValue.delete(),
      'namaAnak': FieldValue.delete(),
      'kelasId': FieldValue.delete(),
    });
  }

  // Future<void> saveFCM() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final token = await FirebaseMessaging.instance.getToken();
  //     if (token != null) {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .update({
  //         'fcmToken': token,
  //       });
  //       print("FCM token berhasil disimpan");
  //     } else {
  //       print("FCM token tidak tersedia");
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(role: widget.role),
      drawer: CustomDrawer(
        namaUser: namaUser,
        fotoPath: fotoPath,
        menuItems: [
          {
            'title': 'Profil',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(role: widget.role),
                ),
              );
            }
          },
          {
            'title': 'Informasi Anak',
            'onTap': () {
              if (anak != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilSiswaPage(
                      siswa: anak!,
                      role: widget.role,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeyAnakPage(role: widget.role),
                  ),
                );
              }
            }
          },
          {
            'title': 'Bantuan',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BantuanPage(
                          role: widget.role,
                        )),
              );
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
                        logout();
                      },
                      child: Text("Ya",
                          style: TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ),
                  ),
                  SizedBox(width: 16),
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
                      child: Text("Tidak",
                          style: TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                            color: Color(0xff0066FF),
                            fontSize: 18,
                          )),
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
