class TemaLaporan {
  final String id;
  final String siswaId;
  final String tema;
  final String bulan;

  TemaLaporan(
      {required this.id,
      required this.siswaId,
      required this.tema,
      required this.bulan});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siswaId': siswaId,
      'tema': tema,
      'bulan': bulan,
    };
  }

  factory TemaLaporan.fromMap(Map<dynamic, dynamic> map) {
    return TemaLaporan(
        id: map['id'],
        siswaId: map['siswaId'],
        tema: map['tema'],
        bulan: map['bulan']);
  }
}
