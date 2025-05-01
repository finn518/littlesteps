import 'package:flutter/material.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class CatatankesehatanPage extends StatefulWidget {
  final String role;
  const CatatankesehatanPage({super.key, required this.role});

  @override
  State<CatatankesehatanPage> createState() => _CatatankesehatanPageState();
}

class _CatatankesehatanPageState extends State<CatatankesehatanPage> {
  final judul = TextEditingController();
  final lingkar = TextEditingController();
  final tinggi = TextEditingController();
  final berat = TextEditingController();

  void _showTambahCatatan() {
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
                    'Buat Catatan Kesehatan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(judul, 'Tulis judul semester disini...', ''),
                  const SizedBox(height: 12),
                  _buildTextField(
                      lingkar, 'Tulis lingkaran kepala disini...', 'cm'),
                  const SizedBox(height: 20),
                  _buildTextField(tinggi, 'Tulis tinggi badan disini...', 'cm'),
                  const SizedBox(height: 20),
                  _buildTextField(berat, 'Tulis berat badan disini...', 'kg'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                            () {}); // Untuk memperbarui tampilan jika ada data baru
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
                        'Buat Catatan Kesehatan',
                        textAlign: TextAlign.center,
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

  Widget _buildTextField(
      TextEditingController controller, String hint, String suffix) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          suffixText: suffix.isNotEmpty ? suffix : null,
          suffixStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.5,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ));
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
              "Catatan Kesehatan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 40),
          CardCatatan(
            number: 1,
            body: content(),
            title: "Semester 1",
          ),
          SizedBox(height: 15),
          CardCatatan(
            number: 2,
            body: content(),
            title: "Semester 2",
          ),
          SizedBox(height: 15),
          CardCatatan(
            number: 3,
            body: content(),
            title: "Semester 3",
          ),
          SizedBox(height: 15),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton(
              onPressed: _showTambahCatatan,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
              shape: const CircleBorder(),
            )
          : null,
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lingkaran Kepala :", style: TextStyle(fontSize: 14)),
          SizedBox(height: 4),
          Text("Tinggi Badan :", style: TextStyle(fontSize: 14)),
          SizedBox(height: 4),
          Text("Berat Badan :", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
