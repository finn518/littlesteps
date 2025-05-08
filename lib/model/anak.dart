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

// final List<Siswa> siswaKelasA = [
//   Siswa(name: 'Budi', imagePath: 'assets/images/kid_face.png'),
//   Siswa(name: 'Karim', imagePath: 'assets/images/kid_face.png'),
//   Siswa(
//       name: 'Siti Fatimah',
//       imagePath: 'assets/images/siti.png',
//       parentName: 'Bu Mira',
//       isConnected: true),
//   Siswa(
//       name: 'Mada',
//       imagePath: 'assets/images/kid_face.png',
//       parentName: 'Pak Hail',
//       isConnected: true),
//   Siswa(
//       name: 'Uni',
//       imagePath: 'assets/images/kid_face.png',
//       parentName: 'Bu Cindy',
//       isConnected: true),
//   Siswa(name: 'Ipu', imagePath: 'assets/images/kid_face.png'),
// ];

// final List<Siswa> siswaKelasB = [
//   Siswa(name: 'Armin', imagePath: 'assets/images/kid_face.png'),
//   Siswa(
//       name: 'Marta',
//       imagePath: 'assets/images/kid_face.png',
//       parentName: 'Bu Cahya',
//       isConnected: true),
//   Siswa(name: 'Loki', imagePath: 'assets/images/kid_face.png'),
//   Siswa(
//       name: 'Yohan',
//       imagePath: 'assets/images/kid_face.png',
//       parentName: 'Bu Adele',
//       isConnected: true),
//   Siswa(name: 'Mika', imagePath: 'assets/images/kid_face.png'),
//   Siswa(
//       name: 'Lola',
//       imagePath: 'assets/images/kid_face.png',
//       parentName: 'Lady Gaga',
//       isConnected: true),
// ];
