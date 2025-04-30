import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/pages/Guru/siswa.dart';

class KehadiranPage extends StatefulWidget {
  @override
  _KehadiranPageState createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  String? selectedKelas;
  List<Siswa> siswaList = [];
  Map<String, String> absensi = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.black)),
          title: Text("Kehadiran",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff53B1FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedKelas = 'A';
                          siswaList = siswaKelasA;
                        });
                      },
                      child: const Text(
                        'Kelas A',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFDE272),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedKelas = 'B';
                          siswaList = siswaKelasB;
                        });
                      },
                      child: const Text(
                        'Kelas B',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: TextStyle(color: Colors.black)),
            const Divider(
              color: Colors.black,
            ),
            Expanded(
                child: selectedKelas == null
                    ? const Center(child: Text('Pilih kelas terlebih dahulu'))
                    : ListView.builder(
                        itemCount: siswaList.length,
                        itemBuilder: (context, index) {
                          final siswa = siswaList[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedKelas == 'A'
                                  ? Color.lerp(
                                      Color(0xFF53B1FD), Colors.white, 0.5)
                                  : Color.lerp(
                                      Color(0xFFFDE272), Colors.white, 0.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: (siswa.imagePath.isEmpty)
                                          ? AssetImage('assets/kid_face.png')
                                          : (siswa.imagePath
                                                      .startsWith('assets')
                                                  ? AssetImage(siswa.imagePath)
                                                  : FileImage(
                                                      File(siswa.imagePath)))
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    siswa.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: DropdownButtonHideUnderline(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        isExpanded: true,
                                        hint: Text(
                                          'Pilihan Absensi',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: absensi[siswa.name],
                                        icon: const Icon(Icons.arrow_drop_down),
                                        borderRadius: BorderRadius.circular(12),
                                        items: [
                                          'Hadir',
                                          'Izin',
                                          'Sakit',
                                          'Absen'
                                        ]
                                            .map((status) => DropdownMenuItem(
                                                  value: status,
                                                  child: Text(status),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            absensi[siswa.name] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        })),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {},
                    child: const Text(
                      'Simpan Kehadiran',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ))
          ],
        ));
  }
}
