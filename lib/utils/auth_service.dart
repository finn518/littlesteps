import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? get currentUser => firebaseAuth.currentUser;

  // login Email and Password
  Future<String?> signInWithEmail({
    required String email,
    required String password,
    required String selectedRole,
  }) async {
    try {
      UserCredential cred =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (user == null) {
        return 'User tidak ditemukan.';
      }

      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        return 'Email belum diverifikasi. Silakan cek email Anda.';
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String storedRole = userDoc['role'];

      if (storedRole != selectedRole) {
        await FirebaseAuth.instance.signOut();
        return 'Akun Tidak terdaftar}';
      }

      return null;
    } catch (e) {
      debugPrint('Error saat login: $e');
      return 'Email atau password salah.';
    }
  }




  // Sign Up Email and Password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.sendEmailVerification();

      return cred.user;
    } catch (e) {
      debugPrint('Error saat register: $e');
      return null;
    }
  }

  Future<void> saveUserData(
      String uid, String sapaan, String nama,
      String email, String nomor, String role) async {
    try {
      await firestore.collection('users').doc(uid).set({
        'sapaan': sapaan,
        'name': nama,
        'email': email,
        'nomor': nomor,
        'role': role,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

  Future<UserCredential> signInWithGoogle({required String role}) async {
    try {
      if (role.isEmpty) throw Exception('Role tidak boleh kosong');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Login dengan Google dibatalkan');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final docRef = firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) {
          await docRef.set({
            'email': user.email ?? '',
            'name': user.displayName ?? '',
            'nomer': user.phoneNumber ?? '',
            'role': role,
            'createdAt': FieldValue.serverTimestamp(),
          });
          debugPrint('Data pengguna baru berhasil disimpan di Firestore');
        } else {
          debugPrint('Pengguna sudah ada di Firestore');
        }
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error selama signInWithGoogle: $e');
      rethrow;
    }
  }

  // Log out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Lupa Password
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String?> updateUserEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        return 'Verifikasi telah dikirim ke email baru. Silakan cek dan konfirmasi.';
      } else {
        return 'User tidak ditemukan.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Verifikasi telah dikirim ke email, silahkan cek lalu login ulang untuk mengubah email.';
      }
      return 'Gagal mengubah email: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }
}
