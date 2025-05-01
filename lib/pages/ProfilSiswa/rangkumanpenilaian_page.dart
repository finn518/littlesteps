import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ProfilSiswa/detailpenilaian_page.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class RangkumanPerkembanganPage extends StatefulWidget {
  final String role;
  const RangkumanPerkembanganPage({super.key, required this.role});

  @override
  State<RangkumanPerkembanganPage> createState() =>
      _RangkumanPerkembanganPageState();
}

class _RangkumanPerkembanganPageState extends State<RangkumanPerkembanganPage> {
  String? selectedSemester;
  final semester = TextEditingController();
  final judul = TextEditingController();
  final catatan = TextEditingController();

  void _showTambahRangkuman() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Buat Rangkuman\nPenilaian',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(semester, 'Tulis pilihan semester disini...'),
                  const SizedBox(height: 12),
                  _buildTextField(judul, 'Tulis judul Anda disini...'),
                  const SizedBox(height: 12),
                  _buildTextField(catatan, 'Tulis catatan Anda disini...',
                      maxLines: 5),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Maish kosong
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Buat Rangkuman Penilaian',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
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

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == 'Guru';
    return Scaffold(
      backgroundColor: Color(0xFFEFF8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF8FA),
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Rangkuman Penilaian",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Pilihan Semester : ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 170, maxHeight: 30),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: false, // Changed to false
                      hint: Text(
                        "Memilih Semester",
                        style: TextStyle(fontSize: 12),
                      ),
                      value: selectedSemester,
                      icon: Icon(Icons.arrow_drop_down),
                      items: [
                        DropdownMenuItem(
                          value: "Semester 1",
                          child: Text(
                            "Semester 1",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Semester 2",
                          child: Text(
                            "Semester 2",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (selectedSemester != null) ...[
              CardCatatan(
                number: 1,
                title: "Nilai Agama Dan Moral",
                body: cardContent(),
              ),
              SizedBox(height: 16),
              CardCatatan(
                number: 2,
                title: "Sosial Emosional",
                body: cardContent(),
              ),
              SizedBox(height: 16),
              CardCatatan(
                number: 3,
                title: "Fisik Motorik",
                body: cardContent(),
              ),
              SizedBox(height: 16),
              CardCatatan(
                number: 4,
                title: "Bahasa",
                body: cardContent(),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: _showTambahRangkuman,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
              shape: const CircleBorder(),
            )
          : null,
    );
  }

  Widget cardContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Catatan: . . .",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 220,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DetailPenilaianPage(role: widget.role)));
                },
                child: Text(
                  "Lihat Rincian",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
