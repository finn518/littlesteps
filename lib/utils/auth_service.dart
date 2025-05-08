import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://littlesteps-52095-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .ref();
  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();

  // Sign In Email and Password
  Future<String?> signInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Get data from Realtime Database
      final snapshot =
          await database.child('users/${userCredential.user!.uid}').get();
      if (snapshot.exists) {
        return snapshot.child('role').value.toString();
      } else {
        return 'User data not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Sign Up Email and Password
  Future<String?> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String nomer,
      required String role}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await database.child('users/${userCredential.user!.uid}').set({
        'email': email,
        'name': name,
        'nomer': nomer,
        'role': role,
        'createdAt': ServerValue.timestamp,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential> signInWithGoogle({required String role}) async {
    try {
      if (role.isEmpty) {
        throw Exception('Role tidak boleh kosong');
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Login dengan Google dibatalkan');
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userRef = database.child('users/${user.uid}');
        final snapshot = await userRef.get();

        if (!snapshot.exists) {
          await userRef.set({
            'email': user.email ?? '',
            'name': user.displayName ?? '',
            'nomer': user.phoneNumber ?? '',
            'role': role,
            'createdAt': ServerValue.timestamp,
          });
          print('Data pengguna baru berhasil disimpan di Realtime Database');
        } else {
          print('Pengguna sudah ada di database');
        }
      }

      return userCredential;
    } catch (e) {
      print('Error selama signInWithGoogle: $e');
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
}
