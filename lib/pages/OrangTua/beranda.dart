import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/pages/OrangTua/jadwal_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/postcard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String? kelasId;
  List<DocumentSnapshot> postingan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Ambil data user login
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userSnapshot.data();
      if (userData == null || userData['kelasId'] == null) {
        setState(() {
          kelasId = null;
          isLoading = false;
        });
        return;
      }

      kelasId = userData['kelasId'];

      // Fetch data postingan dari koleksi kelas
      final postSnapshot = await FirebaseFirestore.instance
          .collection('kelas')
          .doc(kelasId)
          .collection('postingan')
          .orderBy('dateUpload')
          .get();

      setState(() {
        postingan = postSnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kelasId == null) {
      return Center(
        child: Text(
          "Anda belum terhubung dalam kelas apapun",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      children: [
        calenderBtn(context),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('kelas')
              .doc(kelasId)
              .collection('postingan')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Belum ada postingan."));
            }

            final postingan = snapshot.data!.docs;

            return Column(
              children: postingan.map((doc) {
                final data = doc.data()! as Map<String, dynamic>;
                return PostCard(
                  postId: doc.id,
                  userPhoto: data['userPhoto'] ?? '',
                  userName: data['userName'] ?? 'Anonim',
                  dateUpload: data['dateUpload'],
                  caption: data['caption'] ?? '',
                  filePath: data['filePath'] ?? '',
                  likes: data['likes'] ?? 0,
                  isGuru: false,
                  onDelete: () {},
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }


  Widget calenderBtn(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => JadwalHarianPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffB2DDFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 60,
                  height: 45,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff53B1FD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const ImageIcon(
                    AssetImage('assets/icons/Jadwal_harian.png'),
                    color: Colors.white,
                  )),
              const Text(
                "Jadwal Harian",
                style: TextStyle(
                  fontVariations: [FontVariation('wght', 800)],
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }
}
