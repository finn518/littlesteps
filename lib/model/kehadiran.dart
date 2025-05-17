class Kehadiran {
  final String id;
  final String siswaId;
  final String kelasId;
  final String status;
  final String tanggal;
  final int semester;

  Kehadiran(
      {required this.id,
      required this.siswaId,
      required this.kelasId,
      required this.status,
      required this.tanggal,
      required this.semester});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siswaId': siswaId,
      'kelasId': kelasId,
      'status': status,
      'tanggal': tanggal,
      'semester': semester,
    };
  }

  factory Kehadiran.fromMap(Map<dynamic, dynamic> map) {
    return Kehadiran(
        id: map['id'],
        siswaId: map['siswaId'],
        kelasId: map['kelasId'],
        status: map['status'],
        tanggal: map['tanggal'],
        semester: map['semester']);
  }
}
