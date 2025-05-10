class Anak {
  final String id;
  final String nama;
  final String namaPanggilan;
  final String fotoPath;
  final String idKelas;
  String? parentName;
  bool isConnected;

  Anak(
      {required this.id,
      required this.nama,
      required this.namaPanggilan,
      required this.fotoPath,
      required this.idKelas,
      this.parentName,
      this.isConnected = false});

  String get fullImageUrl =>
      'https://rsftbavuwvfqmdedqsdb.supabase.co/storage/v1/object/public/anak/$fotoPath';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'namaPanggilan': namaPanggilan,
      'fotoPath': fotoPath,
      'idKelas': idKelas,
      'parentName': parentName,
      'isConnected': isConnected,
    };
  }

  factory Anak.fromMap(Map<dynamic, dynamic> map) {
    return Anak(
        id: map['id'],
        nama: map['nama'],
        namaPanggilan: map['namaPanggilan'],
        fotoPath: map['fotoPath'],
        idKelas: map['idKelas'],
        parentName: map['parentName'],
        isConnected: map['isConnected'] ?? false);
  }
}
