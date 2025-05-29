import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  final String role;

  const NotifikasiPage({super.key, required this.role});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FDFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FDFF),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 36,
          ),
        ),
        title: Text(
          "Notifikasi ${widget.role}",
          style: TextStyle(
            fontVariations: [FontVariation('wght', 800)],
          ),
        ),
        centerTitle: true,
      ),
      body: buildNotificationStream(),
    );
  }

  Widget buildNotificationStream() {
    if (currentUser == null) {
      return const Center(child: Text("Anda belum login"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('notifikasi')
          .orderBy('waktu', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Terjadi kesalahan"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text("Belum ada notifikasi"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final fotoUser = data['fotoUser'] ?? '';
            final pesan = data['pesan'] ?? '';
            final timestamp = data['waktu'] as Timestamp?;
            final time = timestamp != null
                ? formatTimestamp(timestamp)
                : 'Waktu tidak diketahui';

            return notifikasiTile(
              imagePath: fotoUser,
              title: pesan,
              time: time,
            );
          },
        );
      },
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Hari ini ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }

  Widget notifikasiTile({
    required String imagePath,
    required String title,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: imagePath.startsWith("http")
                ? NetworkImage(imagePath)
                : const AssetImage('assets/images/default.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontVariations: [FontVariation('wght', 500)],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontVariations: [FontVariation('wght', 600)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
