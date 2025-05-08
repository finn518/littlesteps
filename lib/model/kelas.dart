class Kelas {
  final String id;
  final String nama;
  final String tahunAjaran;
  final String gambarKelas;

  Kelas(
      {required this.id,
      required this.nama,
      required this.tahunAjaran,
      required this.gambarKelas});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'tahunAjaran': tahunAjaran,
      'gambarKelas': gambarKelas,
    };
  }

  factory Kelas.fromMap(Map<dynamic, dynamic> map) {
    return Kelas(
        id: map['id'],
        nama: map['nama'],
        tahunAjaran: map['tahunAjaran'],
        gambarKelas: map['gambarKelas']);
  }

  String get fullImageUrl =>
      'https://rsftbavuwvfqmdedqsdb.supabase.co/storage/v1/object/public/kelas/$gambarKelas';
}
