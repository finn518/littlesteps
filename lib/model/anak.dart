class Anak {
  final String id;
  final String nama;
  final String namaPanggilan;
  final String fotoPath;
  final String idKelas;
  final String? specialCode;
  final DateTime? codeGeneratedAt;
  final String? parentName;
  final bool isConnected;

  Anak({
    required this.id,
    required this.nama,
    required this.namaPanggilan,
    required this.fotoPath,
    required this.idKelas,
    this.specialCode,
    this.codeGeneratedAt,
    this.parentName,
    this.isConnected = false,
  });

  factory Anak.fromMap(Map<String, dynamic> map) {
    return Anak(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      namaPanggilan: map['namaPanggilan'] ?? '',
      fotoPath: map['fotoPath'] ?? '',
      idKelas: map['idKelas'] ?? '',
      specialCode: map['specialCode'],
      codeGeneratedAt: map['codeGeneratedAt']?.toDate(),
      parentName: map['parentName'],
      isConnected: map['isConnected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'namaPanggilan': namaPanggilan,
      'fotoPath': fotoPath,
      'idKelas': idKelas,
      'specialCode': specialCode,
      'codeGeneratedAt': codeGeneratedAt,
      'parentName': parentName,
      'isConnected': isConnected,
    };
  }
}
