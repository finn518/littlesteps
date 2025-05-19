import 'package:cloud_firestore/cloud_firestore.dart';

class Pengumuman {
  final String id;
  final String kelasId;
  final String pengirimId;
  final String isiPesan;
  final String filePath;
  final DateTime timestamp;

  Pengumuman({
    required this.id,
    required this.kelasId,
    required this.pengirimId,
    required this.isiPesan,
    required this.filePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kelasId': kelasId,
      'pengirimId': pengirimId,
      'isiPesan': isiPesan,
      'filePath': filePath,
      'timestamp': timestamp
    };
  }

  factory Pengumuman.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pengumuman(
      id: data['id'] ?? doc.id,
      kelasId: data['kelasId'] ?? '',
      pengirimId: data['pengirimId'] ?? '',
      isiPesan: data['isiPesan'] ?? '',
      filePath: data['filePath'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}
