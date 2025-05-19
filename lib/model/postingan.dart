import 'package:cloud_firestore/cloud_firestore.dart';

class Postingan {
  final String id;
  final String userName;
  final String dateUpload;
  final String caption;
  final String filePath;
  final int likes;
  final String userPhoto;

  Postingan({
    required this.id,
    required this.userName,
    required this.dateUpload,
    required this.caption,
    required this.filePath,
    required this.likes,
      required this.userPhoto
  });

  // Factory method untuk membuat instance dari Firestore document
  factory Postingan.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Postingan(
      id: data['id'] ?? doc.id,
      userName: data['userName'] ?? '',
      dateUpload: data['dateUpload'] ?? '',
      caption: data['caption'] ?? '',
      filePath: data['filePath'] ?? '',
      likes: data['likes'] ?? '',
      userPhoto: data['userPhoto'] ?? '',

    );
  }

  // Untuk mengubah objek menjadi Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'dateUpload': dateUpload,
      'caption': caption,
      'filePath': filePath,
      'likes': likes,
      'userPhoto': userPhoto,
    };
  }
}
