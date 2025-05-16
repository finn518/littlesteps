import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RangkumanKehadiran extends StatefulWidget {
  final String kelasId;
  final String siswaId;

  const RangkumanKehadiran(
      {super.key, required this.kelasId, required this.siswaId});

  @override
  State<RangkumanKehadiran> createState() => _RangkumanKehadiranState();
}

class _RangkumanKehadiranState extends State<RangkumanKehadiran> {
  final Map<int, Map<String, int>> rekap = {};

  @override
  void initState() {
    super.initState();
    ambilDataKehadiran();
  }

  Future<void> ambilDataKehadiran() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('kehadiran')
        .where('siswaId', isEqualTo: widget.siswaId)
        .get();

    final data = <int, Map<String, int>>{};

    for (var doc in snapshot.docs) {
      final semester = doc['semester'] ?? 0;
      final status = (doc['status'] ?? 'Absen') as String;

      if (!data.containsKey(semester)) {
        data[semester] = {
          'Hadir': 0,
          'Sakit': 0,
          'Izin': 0,
          'Absen': 0,
        };
      }
      data[semester]![status] = (data[semester]![status] ?? 0) + 1;
    }

    setState(() {
      rekap.clear();
      rekap.addAll(data);
    });
  }

  Widget semesterCard(int semester) {
    final info = rekap[semester] ??
        {
          'Hadir': 0,
          'Sakit': 0,
          'Izin': 0,
          'Absen': 0,
        };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Semester $semester',
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(
            color: Colors.black,
            thickness: 1.5,
          ),
          Text(
            'Hadir : ${info['Hadir']}',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          Text(
            'Sakit : ${info['Sakit']}',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          Text(
            'Izin : ${info['Izin']}',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          Text(
            'Alpa : ${info['Absen']}',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Text(
            'Rangkuman Kehadiran',
            style: TextStyle(
                fontVariations: [FontVariation('wght', 800)], fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          for (var i = 1; i <= 4; i++) semesterCard(i),
        ],
      ),
    );
  }
}
