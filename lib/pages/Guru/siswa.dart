class Siswa {
  final String name;
  final String imagePath;
  String? parentName;
  bool isConnected;

  Siswa(
      {required this.name,
      required this.imagePath,
      this.parentName,
      this.isConnected = false});
}

final List<Siswa> siswaKelasA = [
  Siswa(name: 'Budi', imagePath: 'assets/images/kid_face.png'),
  Siswa(name: 'Karim', imagePath: 'assets/images/kid_face.png'),
  Siswa(
      name: 'Siti Fatimah',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Bu Mira',
      isConnected: true),
  Siswa(
      name: 'Mada',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Pak Hail',
      isConnected: true),
  Siswa(
      name: 'Uni',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Bu Cindy',
      isConnected: true),
  Siswa(name: 'Ipu', imagePath: 'assets/images/kid_face.png'),
];

final List<Siswa> siswaKelasB = [
  Siswa(name: 'Armin', imagePath: 'assets/images/kid_face.png'),
  Siswa(
      name: 'Marta',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Bu Cahya',
      isConnected: true),
  Siswa(name: 'Loki', imagePath: 'assets/images/kid_face.png'),
  Siswa(
      name: 'Yohan',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Bu Adele',
      isConnected: true),
  Siswa(name: 'Mika', imagePath: 'assets/images/kid_face.png'),
  Siswa(
      name: 'Lola',
      imagePath: 'assets/images/kid_face.png',
      parentName: 'Lady Gaga',
      isConnected: true),
];
