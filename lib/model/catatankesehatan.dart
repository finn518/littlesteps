class CatatanKesehatan {
  final String id;
  final String siswaId;
  final double lingkarKepala;
  final double beratBadan;
  final double tinggiBadan;
  final String semester;

  CatatanKesehatan(
      {required this.id,
      required this.siswaId,
      required this.lingkarKepala,
      required this.beratBadan,
      required this.tinggiBadan,
      required this.semester});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siswaId': siswaId,
      'lingkarKepala': lingkarKepala,
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'semester': semester,
    };
  }

  factory CatatanKesehatan.fromMap(Map<dynamic, dynamic> map) {
    return CatatanKesehatan(
        id: map['id'],
        siswaId: map['siswaId'],
        lingkarKepala: map['lingkarKepala'],
        beratBadan: map['beratBadan'],
        tinggiBadan: map['tinggiBadan'],
        semester: map['semester']);
  }
}
