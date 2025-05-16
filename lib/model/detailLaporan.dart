import 'package:cloud_firestore/cloud_firestore.dart';

class DetailLaporan {
  final String id;
  final String temaId;
  final String judul;
  final String catatan;
  final DateTime createdAt;

  DetailLaporan(
      {required this.id,
      required this.temaId,
      required this.judul,
      required this.catatan,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temaId': temaId,
      'judul': judul,
      'catatan': catatan,
      'createdAt': createdAt,
    };
  }

  factory DetailLaporan.fromMap(Map<dynamic, dynamic> map) {
    return DetailLaporan(
        id: map['id'],
        temaId: map['temaId'],
        judul: map['judul'],
        catatan: map['catatan'],
        createdAt: (map['createdAt'] as Timestamp).toDate());
  }
}
