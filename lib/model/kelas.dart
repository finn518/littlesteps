class Kelas {
  final String id;
  final String nama;
  final String tahunAngkatan;
  final String gambarKelas;

  Kelas(
      {required this.id,
      required this.nama,
      required this.tahunAngkatan,
      required this.gambarKelas});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'tahunAngkatan': tahunAngkatan,
      'gambarKelas': gambarKelas,
    };
  }

  factory Kelas.fromMap(Map<dynamic, dynamic> map) {
    return Kelas(
        id: map['id'],
        nama: map['nama'],
        tahunAngkatan: map['tahunAngkatan'],
        gambarKelas: map['gambarKelas'] is List
            ? (map['gambarKelas'] as List).first
            : map['gambarKelas']);
  }

  String get fullImageUrl {
    if (gambarKelas.startsWith("http")) {
      return gambarKelas;
    }
    return "https://rsftbavuwvfqmdedqsdb.supabase.co/storage/v1/object/public/kelas/images/$gambarKelas";
  }
}
