import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifikasiPage extends StatefulWidget {
  final String role;

  const NotifikasiPage({super.key, required this.role});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _sudahCekNotifikasi = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      // _sudahCekNotifikasi = true;
      cekDanTambahNotifikasiTerjadwal();
    }
  }

  DateTime parseJamString(String jamStr) {
    final now = DateTime.now();
    jamStr = jamStr.replaceAll('.', ':');
    final parts = jamStr.split(':');

    if (parts.length != 2) {
      throw FormatException("Format jam tidak valid: $jamStr");
    }

    final jam = int.parse(parts[0]);
    final menit = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, jam, menit);
  }

  Future<void> cekDanTambahNotifikasiTerjadwal() async {
    final now = DateTime.now();
    final firestore = FirebaseFirestore.instance;

    final jadwalSnapshot = await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('jadwal')
        .get();

    final snapshotDihapus = await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('notifikasi_dihapus')
        .get();
    final Set<String> notifikasiDihapusSet = snapshotDihapus.docs
        .map((doc) => "${doc['id']}_${doc['label']}")
        .toSet();

    for (final doc in jadwalSnapshot.docs) {
      final data = doc.data();
      final waktuJadwal = data['waktu'] is Timestamp
          ? (data['waktu'] as Timestamp).toDate()
          : parseJamString(data['waktu']);

      final judul = data['catatan'] ?? 'Jadwal';

      final Map<String, Duration> reminderWaktu = {
        'H-1': Duration(hours: 24),
        '12 Jam': Duration(hours: 12),
        '2 Jam': Duration(hours: 2),
        'Waktu Jadwal': Duration.zero,
      };

      for (final entry in reminderWaktu.entries) {
        final key = entry.key;
        final delta = entry.value;
        final targetTime = waktuJadwal.subtract(delta);

        final sudahLewat = now.isAfter(targetTime);

        final isTepatWaktu = key == 'Waktu Jadwal'
            ? sudahLewat && now.difference(targetTime).inMinutes <= 60
            : sudahLewat;

        final uniqueKey = "${doc.id}_$key";
        if (isTepatWaktu && !notifikasiDihapusSet.contains(uniqueKey)) {
          final notif = await firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('notifikasi')
              .where('id', isEqualTo: doc.id)
              .where('label', isEqualTo: key)
              .get();

          if (notif.docs.isEmpty) {
            await firestore
                .collection('users')
                .doc(currentUser!.uid)
                .collection('notifikasi')
                .add({
              'waktu': FieldValue.serverTimestamp(),
              'pesan':
                  'REMINDER!!! $key untuk jadwal "$judul" pada ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(waktuJadwal)}',
              'id': doc.id,
              'label': key,
            });
          }
        }
      }
    }
  }

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
              notifId: docs[index].id,
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
    required String notifId,
  }) {
    final firestore = FirebaseFirestore.instance;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
          ),
          child: Row(
            children: [
              (imagePath.isNotEmpty)
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: imagePath.startsWith("http")
                          ? NetworkImage(imagePath)
                          : AssetImage(imagePath) as ImageProvider,
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.notifications,
                        color: Colors.grey[800],
                        size: 24,
                      ),
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
        ),
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: () async {
              try {
                final docSnapshot = await firestore
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('notifikasi')
                    .doc(notifId)
                    .get();

                final data = docSnapshot.data();
                if (data != null) {
                  await firestore
                      .collection('users')
                      .doc(currentUser!.uid)
                      .collection('notifikasi_dihapus')
                      .add({
                    'id': data['id'],
                    'label': data['label'],
                    'waktu_dihapus': FieldValue.serverTimestamp(),
                  });
                }

                await firestore
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('notifikasi')
                    .doc(notifId)
                    .delete();
              } catch (e) {
                print('Gagal menghapus notifikasi: $e');
              }
            },
            child: Image.asset(
              'assets/icons/close.png',
              width: 20,
              height: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
