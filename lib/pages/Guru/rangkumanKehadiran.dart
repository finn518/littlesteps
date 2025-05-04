import 'package:flutter/material.dart';

class RangkumanKehadiran extends StatelessWidget {
  const RangkumanKehadiran({super.key});

  Widget semesterCard(String semester) {
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
          const Text(
            'Hadir : ',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          const Text(
            'Sakit : ',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          const Text(
            'Izin : ',
            style: TextStyle(
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
          const Text(
            'Alpa : ',
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
          semesterCard('1'),
          semesterCard('2'),
          semesterCard('3'),
          semesterCard('4'),
          semesterCard('5'),
        ],
      ),
    );
  }
}
