import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String kelasId;
  final String pengirimId;
  final String penerimaId;
  final String isiPesan;
  final String filePath;
  final DateTime timestamp;

  Chat({
    required this.id,
    required this.kelasId,
    required this.pengirimId,
    required this.penerimaId,
    required this.isiPesan,
    required this.filePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kelasId': kelasId,
      'pengirimId': pengirimId,
      'penerimaId': penerimaId,
      'isiPesan': isiPesan,
      'filePath': filePath,
      'timestamp': timestamp
    };
  }

  factory Chat.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: data['id'] ?? doc.id,
      kelasId: data['kelasId'] ?? '',
      pengirimId: data['pengirimId'] ?? '',
      penerimaId: data['penerimaId'] ?? '',
      isiPesan: data['isiPesan'] ?? '',
      filePath: data['filePath'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
