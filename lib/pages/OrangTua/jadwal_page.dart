import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/model/Jadwal.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/widgets/appBackground.dart';

class JadwalHarianPage extends StatefulWidget {
  const JadwalHarianPage({super.key});

  @override
  State<JadwalHarianPage> createState() => _JadwalHarianPageState();
}

class _JadwalHarianPageState extends State<JadwalHarianPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  final catatanController = TextEditingController();
  final tanggalController = TextEditingController();
  final waktuController = TextEditingController();
  String tipeCatatan = "Tugas";
  List<Jadwal> daftarJadwal = [];

  @override
  void initState() {
    super.initState();
    ambilDataJadwal();
  }

  @override
  void dispose() {
    catatanController.dispose();
    tanggalController.dispose();
    waktuController.dispose();
    super.dispose();
  }

  Future<void> ambilDataJadwal() async {
    final snapshot = await firestore
        .collection('users')
        .doc(user?.uid)
        .collection('jadwal')
        .get();

    final List<Jadwal> semuaJadwal =
        snapshot.docs.map((doc) => Jadwal.fromDocument(doc)).toList();

    String tanggalTerpilih =
        DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(_selectedDay);

    setState(() {
      daftarJadwal = semuaJadwal
          .where((jadwal) => jadwal.tanggal == tanggalTerpilih)
          .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 36),
        ),
        title: Text(
          "Jadwal Harian",
          style: TextStyle(
            fontSize: 28,
            fontVariations: [FontVariation('wght', 800)],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: ListView(
          children: [
            Column(
              children: [
                CustomCalendar(),
                SizedBox(height: 16), // Optional spacing
                if (daftarJadwal.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: daftarJadwal.length,
                    itemBuilder: (context, index) {
                      return agenda(daftarJadwal[index]);
                    },
                  ),
                if (daftarJadwal.isEmpty)
                  Center(
                    child: Text("Tidak ada jadwal hari ini"),
                  ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomDrawer(context),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        backgroundColor: Color(0xff4285F4),
      ),
    );
  }

  void openBottomDrawer(BuildContext context,
      {Map<String, dynamic>? existingData}) {
    final TextEditingController catatanController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController waktuController = TextEditingController();
    DateTime? _selectedDay;
    String tipeCatatan = existingData?['tipe'] ?? "";

    // Isi controller jika mode edit
    if (existingData != null) {
      catatanController.text = existingData['catatan'] ?? "";
      tanggalController.text = existingData['tanggal'] ?? "";
      waktuController.text = existingData['waktu'] ?? "";
      try {
        _selectedDay = DateFormat('dd/MM/yyyy').parse(existingData['tanggal']);
      } catch (_) {}
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 45,
                left: 30,
                right: 30,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        existingData == null
                            ? 'Buat jadwal harian'
                            : 'Edit jadwal harian',
                        style: TextStyle(
                          fontSize: 30,
                          fontVariations: [FontVariation('wght', 800)],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tulis catatan anda disini...',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff4285F4), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: tanggalController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Tanggal',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDay ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2050),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedDay = pickedDate;
                                tanggalController.text =
                                    DateFormat('EEEE, dd-MM-yyyy', 'id_ID')
                                        .format(pickedDate);
                              });
                            }
                          },
                          icon: ImageIcon(
                            AssetImage('assets/icons/calender.png'),
                            color: Color(0xffC0C0C0),
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: waktuController,
                      decoration: InputDecoration(
                        hintText: 'Keterangan waktu',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffC0C0C0), width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tipeCatatan == "Tugas"
                                  ? Colors.blue[100]
                                  : Colors.blue[50],
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                tipeCatatan = "Tugas";
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                      'assets/icons/Tugas_lingkaran.png'),
                                  color: Color(0xff4285F4),
                                ),
                                SizedBox(width: 8),
                                Text('Tugas'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tipeCatatan == "Kegiatan"
                                  ? Colors.green[100]
                                  : Colors.blue[50],
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                tipeCatatan = "Kegiatan";
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                      'assets/icons/Kegiatan_lingkaran.png'),
                                  color: Color(0xff00B383),
                                ),
                                SizedBox(width: 8),
                                Text('Kegiatan'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final catatan = catatanController.text.trim();
                        final tanggal = tanggalController.text.trim();
                        final waktu = waktuController.text.trim();

                        if (catatan.isNotEmpty &&
                            tanggal.isNotEmpty &&
                            waktu.isNotEmpty) {
                          final userRef =
                              firestore.collection('users').doc(user?.uid);
                          final jadwalRef = userRef.collection('jadwal');

                          if (existingData == null) {
                            // CREATE JADWAL BARU
                            final docId = jadwalRef.doc().id;
                            jadwalRef.doc(docId).set({
                              'id': docId,
                              'catatan': catatan,
                              'tanggal': tanggal,
                              'waktu': waktu,
                              'tipe': tipeCatatan,
                              'createdAt': FieldValue.serverTimestamp(),
                            }).then((_) {
                              Navigator.pop(context);
                              ambilDataJadwal(); // ⬅ Ambil data terbaru
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Jadwal berhasil disimpan')),
                              );
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal menyimpan: $e')),
                              );
                            });
                          } else {
                            // MODE EDIT - cek perubahan
                            final hasChanges =
                                catatan != existingData['catatan'] ||
                                    tanggal != existingData['tanggal'] ||
                                    waktu != existingData['waktu'] ||
                                    tipeCatatan != existingData['tipe'];

                            if (!hasChanges) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tidak ada perubahan')),
                              );
                              return;
                            }

                            final docId = existingData['id'];
                            jadwalRef.doc(docId).update({
                              'catatan': catatan,
                              'tanggal': tanggal,
                              'waktu': waktu,
                              'tipe': tipeCatatan,
                            }).then((_) {
                              Navigator.pop(context);
                              ambilDataJadwal(); // ⬅ Ambil data terbaru setelah update
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Jadwal berhasil diperbarui')),
                              );
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Gagal memperbarui: $e')),
                              );
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Harap isi semua field')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4285F4),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          existingData == null
                              ? "Buat Jadwal"
                              : "Update Jadwal",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, String nama, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda yakin\ningin menghapus jadwal harian?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xff0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteJadwal(id);
                      },
                      child: Text(
                        "Ya",
                        style: TextStyle(
                          fontVariations: [FontVariation('wght', 800)],
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Tidak",
                        style: TextStyle(
                          fontVariations: [FontVariation('wght', 800)],
                          color: Color(0xff0066FF),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _deleteJadwal(String jadwalId) async {
    try {
      await firestore
          .collection('users')
          .doc(user?.uid)
          .collection('jadwal')
          .doc(jadwalId)
          .delete();

      setState(() {
        daftarJadwal.removeWhere((jadwal) => jadwal.id == jadwalId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Jadwal berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus jadwal: ${e.toString()}")),
      );
    }
  }

Widget agenda(Jadwal jadwal) {
    return GestureDetector(
      onTap: () => openBottomDrawer(context, existingData: {
        'id': jadwal.id,
        'catatan': jadwal.catatan,
        'tanggal': jadwal.tanggal,
        'waktu': jadwal.waktu,
        'tipe': jadwal.tipe,
      }),
      onLongPress: () => showDeleteDialog(context, jadwal.catatan, jadwal.id),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.radio_button_checked,
                      color: jadwal.tipe == "Tugas"
                          ? Color(0xff4285F4)
                          : Color(0xff00B383),
                      size: 16),
                  SizedBox(width: 8),
                  Text(
                    jadwal.waktu,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontVariations: [FontVariation('wght', 700)],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.more_horiz, color: Colors.grey),
                ],
              ),
              SizedBox(height: 8),
              Text(
                jadwal.catatan,
                style: TextStyle(
                  fontSize: 18,
                  fontVariations: [FontVariation('wght', 700)],
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                jadwal.tanggal,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontVariations: [FontVariation('wght', 500)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget CustomCalendar() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      }),
                    ),
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.chevron_right),
                      onPressed: () => setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            daysOfWeekHeight: 50,
            calendarStyle: CalendarStyle(
              tablePadding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
              todayDecoration: ShapeDecoration(
                  shape: CircleBorder(), color: Color(0xff4285F4)),
              selectedDecoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Color(0xff4285F4).withOpacity(0.5)),
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              ambilDataJadwal();
            },
            firstDay: DateTime.utc(2015, 1, 1),
            lastDay: DateTime.utc(2045, 12, 31),
            calendarFormat: _calendarFormat,
            headerVisible: false,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                return Center(
                  child: Text(
                    DateFormat('E').format(day).substring(0, 3),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
