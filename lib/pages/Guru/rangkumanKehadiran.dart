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
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(
            color: Colors.black,
            thickness: 1.5,
          ),
          const Text('Hadir : '),
          const Text('Sakit : '),
          const Text('Izin : '),
          const Text('Alpa : '),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Text(
            'Rangkuman Kehadiran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
