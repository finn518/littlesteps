import 'package:flutter/material.dart';
import 'package:littlesteps/pages/ProfilSiswa/detailpenilaian_page.dart';
import 'package:littlesteps/widgets/cardcatatan.dart';

class RangkumanPerkembanganPage extends StatefulWidget {
  const RangkumanPerkembanganPage({super.key});

  @override
  State<RangkumanPerkembanganPage> createState() =>
      _RangkumanPerkembanganPageState();
}

class _RangkumanPerkembanganPageState extends State<RangkumanPerkembanganPage> {
  String? selectedSemester;

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPenilaianPage()));
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
