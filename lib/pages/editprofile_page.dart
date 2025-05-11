import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/kelas.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/Guru/homepage_Guru.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/pages/login_page.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';

class EditProfilePage extends StatefulWidget {
  final String role;
  const EditProfilePage({super.key, required this.role});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final authService = AuthService();
  User? _user;

  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final nomerController = TextEditingController();
  final sapaanController = TextEditingController();

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
          sapaanController.text = data['sapaan'] ?? '';
          namaController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          nomerController.text = data['nomor'] ?? '';
        });
      }
    }
  }

  Future<void> saveChanges() async {
    final user = authService.currentUser;
    final newName = namaController.text.trim();
    final newEmail = emailController.text.trim();
    final newNumber = nomerController.text.trim();
    final newSapaan = sapaanController.text.trim();
    final currentEmail = user?.email ?? '';

    if (user == null) return;

    try {
      final authService = AuthService();
      final isEmailChanged = newEmail != currentEmail;

      if (isEmailChanged) {
        final uid = user.uid;
        final userDoc =
            await authService.firestore.collection('users').doc(uid).get();
        final role = userDoc['role'] ?? 'user';

        // Update email di Firebase Auth
        final result = await authService.updateUserEmail(newEmail);

        // Tampilkan pesan (baik error atau sukses)
        if (result != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result)));
        }

        // Tetap update data lain di Firestore meskipun email butuh verifikasi
        await authService.firestore.collection('users').doc(uid).update({
          'sapaan': newSapaan,
          'name': newName,
          'email': newEmail,
          'nomor': newNumber,
        });

        // Logout dan arahkan ke login page
        await authService.signOut();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(role: role)),
          (route) => false,
        );
      } else {
        // Jika email tidak berubah, cukup update data lainnya
        await authService.firestore.collection('users').doc(user.uid).update({
          'sapaan': newSapaan,
          'name': newName,
          'nomor': newNumber,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui.')),
        );

        // Navigasi ke home sesuai role
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
                builder: (context) => HomePageOrangTua(role: widget.role)),
            (route) => false,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
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
        title: Text(
          "Edit Profil",
          style: TextStyle(
            fontVariations: [FontVariation('wght', 800)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffB2DDFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            editprofil(width),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.14, vertical: height * 0.01),
              child: Column(
                children: [
                  CustomTextField(
                      label: "Nama sapaan (Pak/Bu)",
                      controller: sapaanController),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(label: "Nama", controller: namaController),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(label: "Surel", controller: emailController),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Merubah email memerlukan login ulang",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8A9099),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    label: "Nomor Telepon",
                    controller: nomerController,
                    isNumber: true,
                  ),
                  SizedBox(height: 5),
                  CustomButton(
                    label: "Edit Profil",
                    onPressed: saveChanges,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editprofil(double width) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bgprofil.png"))),
                ),
              ),
              Positioned(
                  left: width * 0.32,
                  bottom: -40,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xff0066FF),
                        child: CircleAvatar(
                          radius: 65, //nanti dikecilin
                          backgroundImage:
                              AssetImage("assets/images/Bu_mira.png"),
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent, // Biar transparan
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/icons/Edit_profil.png',
                                fit: BoxFit.cover,
                                width: 50, // ukuran sesuai radius * 2
                                height: 50,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors
                                    .transparent, // biar button transparan
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    // Aksi saat ditekan
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}
