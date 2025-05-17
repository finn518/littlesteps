import 'package:cloud_firestore/cloud_firestore.dart';
class Jadwal {
  final String id;
  final String catatan;
  final String tanggal;
  final String waktu;
  final String tipe;

  Jadwal({
    required this.id,
    required this.catatan,
    required this.tanggal,
    required this.waktu,
    required this.tipe,
  });

  // Factory method untuk membuat instance dari Firestore document
  factory Jadwal.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Jadwal(
      id: data['id'] ?? doc.id,
      catatan: data['catatan'] ?? '',
      tanggal: data['tanggal'] ?? '',
      waktu: data['waktu'] ?? '',
      tipe: data['tipe'] ?? '',
    );
  }

  // Untuk mengubah objek menjadi Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catatan': catatan,
      'tanggal': tanggal,
      'waktu': waktu,
      'tipe': tipe,
    };
  }
}
