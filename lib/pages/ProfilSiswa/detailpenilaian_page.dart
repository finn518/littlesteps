import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class DetailPenilaianPage extends StatefulWidget {
  final String role;
  const DetailPenilaianPage({super.key, required this.role});

  @override
  State<DetailPenilaianPage> createState() => _DetailPenilaianPageState();
}

class _DetailPenilaianPageState extends State<DetailPenilaianPage> {
  final kompetensi = TextEditingController();
  String? selectedLevel;
  Set<String> selectedLevels = {};

  void _showTambahPPenilaian() {
    final List<Map<String, dynamic>> levels = [
      {'label': 'Belum Muncul', 'color': Color(0xFFFFF1F3)},
      {'label': 'Mulai Muncul', 'color': Color(0xFFFEFBE8)},
      {'label': 'Berkembang Sesuai Harapan', 'color': Color(0xFFEFF8FF)},
      {'label': 'Berkembang Sangat Baik', 'color': Color(0xFFEDFCF2)},
    ];

    String? tempSelectedLevel = selectedLevel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Buat Penilaian Sub Kompetensi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: kompetensi,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tulis sub kompetensi dasar disini...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: levels.map((level) {
                      final isSelected = tempSelectedLevel == level['label'];
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempSelectedLevel = level['label'];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: level['color'],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            level['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedLevel = tempSelectedLevel;
                        });
                        print('Subkompetensi: ${kompetensi.text}');
                        print('Level: $selectedLevel');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Buat Jadwal',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == 'Guru';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 48),
        children: [
          Center(
            child: Text(
              "Laporan Penilaian",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Nilai Agama dan Moral",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Color(0xff707070),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          CardCatatan(
            reverse: true,
            number: 1,
            body: content("Berdoa sebelum dan sesudah melaksanakan kegiatan"),
            title: "Berkembang Sangat Baik",
          ),
          SizedBox(height: 15),
          CardCatatan(
            reverse: true,
            number: 2,
            body: content("Menyanyikan lagu-lagu keagamaan"),
            title: "Berkembang Sangat Baik",
          ),
          SizedBox(height: 15),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: _showTambahPPenilaian,
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
              shape: CircleBorder(),
            )
          : null,
    );
  }

  Widget content(String detail) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
            child: Text(
          detail,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        )));
  }
}
