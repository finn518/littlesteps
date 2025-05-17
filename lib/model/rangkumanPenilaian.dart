class RangkumanPenilaian {
  final String id;
  final String kelasId;
  final String siswaId;
  final String semester;
  final String kompetensiDasar;
  final List<String> subBab;
  final List<String> poinSubBab;
  final List<String> nilai;
  final String catatan;

  RangkumanPenilaian(
      {required this.id,
      required this.kelasId,
      required this.siswaId,
      required this.semester,
      required this.kompetensiDasar,
      required this.subBab,
      required this.poinSubBab,
      required this.nilai,
      required this.catatan});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kelasId': kelasId,
      'siswaId': siswaId,
      'semester': semester,
      'kompetensiDasar': kompetensiDasar,
      'subBab': subBab,
      'poinSubBab': poinSubBab,
      'nilai': nilai,
      'catatan': catatan,
    };
  }

  factory RangkumanPenilaian.fromMap(Map<dynamic, dynamic> map) {
    return RangkumanPenilaian(
      id: map['id'],
      kelasId: map['kelasId'],
      siswaId: map['siswaId'],
      semester: map['semester'],
      kompetensiDasar: map['kompetensiDasar'],
      subBab: map['subBab'] is List ? List<String>.from(map['subBab']) : [],
      poinSubBab:
          map['poinSubBab'] is List ? List<String>.from(map['poinSubBab']) : [],
      nilai: map['nilai'] is List ? List<String>.from(map['nilai']) : [],
      catatan: map['catatan'] ?? 'Tidak ada catatan',
    );
  }
}
