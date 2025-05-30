import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlesteps/pages/Guru/KelasPage.dart';
import 'package:littlesteps/pages/OrangTua/homepage_OrangTua.dart';
import 'package:littlesteps/pages/login_page.dart';
import 'package:littlesteps/utils/auth_service.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String role;
  const EditProfilePage({super.key, required this.role});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final authService = AuthService();
  fb_auth.User? _user;
  File? selectedImage;
  String? fotoPath;

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
          fotoPath = data['fotoPath'];
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
    final uploadedImageUrl = await uploadProfileImage();

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
          if (uploadedImageUrl != null) 'fotoPath': uploadedImageUrl,
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
          if (uploadedImageUrl != null) 'fotoPath': uploadedImageUrl,
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
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgprofil.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xff0066FF),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (fotoPath != null
                              ? (fotoPath!.startsWith('http')
                                  ? NetworkImage(fotoPath!)
                                  : FileImage(File(fotoPath!)) as ImageProvider)
                              : AssetImage('assets/images/Bu_mira.png')
                                  as ImageProvider),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () async {
                        debugPrint("IconButton Detected!");
                        await pickImage();
                      },
                      child: CircleAvatar(
                        radius: 22, // Outer white circle
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 16, // Inner light blue
                          backgroundColor: Colors.blue[100],
                          child: ImageIcon(
                            AssetImage('assets/icons/edit.png'),
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 80),
      ],
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Proses gambar yang dipilih
      setState(() {
        selectedImage = File(image.path);
      });
      debugPrint("Gambar dipilih: ${image.path}");
    }
  }

  Future<String?> uploadProfileImage() async {
    if (selectedImage == null) return null;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'profile_images/$fileName.jpg';

    await Supabase.instance.client.storage
        .from('users')
        .upload(path, selectedImage!);

    final publicUrl =
        Supabase.instance.client.storage.from('users').getPublicUrl(path);

    return publicUrl;
  }
}
