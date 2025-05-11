import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/anak.dart';
import 'package:littlesteps/pages/ResetPassword/resetpasswordflow.dart';
import 'package:littlesteps/pages/success_page.dart';
import 'package:littlesteps/widgets/customTextField.dart';

class KeyAnakPage extends StatefulWidget {
  final String role;
  const KeyAnakPage({super.key, required this.role});

  @override
  State<KeyAnakPage> createState() => _KeyAnakPageState();
}

class _KeyAnakPageState extends State<KeyAnakPage> {
  final keyController = TextEditingController();

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

  Future<void> _connectChild(BuildContext context) async {
    final enteredCode = keyController.text.trim();

    // Validate empty input
    if (enteredCode.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode teks tidak boleh kosong")),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check user authentication
    if (currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda belum login")),
      );
      return;
    }

    try {
      bool isFound = false;
      final kelasSnapshot = await firestore.collection('kelas').get();

      // Search through all classes and children
      for (final kelasDoc in kelasSnapshot.docs) {
        final anakQuery = await firestore
            .collection('kelas')
            .doc(kelasDoc.id)
            .collection('anak')
            .where('specialCode', isEqualTo: enteredCode)
            .limit(1)
            .get();

        if (anakQuery.docs.isNotEmpty) {
          final anakDoc = anakQuery.docs.first;
          final anakData = anakDoc.data();
          final anakId = anakDoc.id;

          if (anakData == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data anak tidak valid")),
            );
            return;
          }

          // Get user data first
          final userDoc =
              await firestore.collection('users').doc(currentUser.uid).get();
          final userData = userDoc.data() ?? {};

          final sapaan = userData['sapaan'] ?? '';
          final nama =
              userData['name'] ?? currentUser.displayName ?? 'Orang Tua';
          final parentName = "$sapaan $nama".trim();

          // Batch update for atomic operation
          final batch = firestore.batch();

          // Update child data
          batch.update(anakDoc.reference, {
            'parentName': parentName,
            'parentId': currentUser.uid,
            'isConnected': true,
            'connectedAt': FieldValue.serverTimestamp(),
          });

          // Update user data
          batch.update(firestore.collection('users').doc(currentUser.uid), {
            'isConnected': true,
            'namaAnak': anakData['nama'] ?? 'Anak',
            'anakId': anakId,
            'kelasId': kelasDoc.id,
            'connectedAt': FieldValue.serverTimestamp(),
          });

          await batch.commit();

          final anak = Anak.fromMap(anakData);

          if (!mounted) return;
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SuccessPage(
                role: widget.role,
                anak: anak,
                isProfile: true,
              ),
            ),
          );

          isFound = true;
          break;
        }
      }

      if (!isFound && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kode tidak ditemukan dalam sistem")),
        );
      }
    } catch (e) {
      print("Error connecting child: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResetPasswordFlow(
      isLogin: true,
      title: "Informasi Anak Anda Belum Terhubung",
      subtitle:
          "Silahkan masukkan kode teks yang telah diberikan guru anak anda",
      buttonText: "Lanjutkan",
      body: CustomTextField(label: "Kode Teks", controller: keyController),
      onButtonPressed: () => _connectChild(context),
    );
  }
}
