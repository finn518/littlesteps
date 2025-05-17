import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/pages/OrangTua/detailgaleri_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  String? _kelasId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final kelasId = userDoc.data()?['kelasId'] as String?;
      if (kelasId == null || kelasId.isEmpty) {
        throw Exception('Belum terhubung dengan anak');
      }

      setState(() {
        _kelasId = kelasId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<Map<String, Map<String, dynamic>>> _fetchMonthsWithContent() async {
    if (_kelasId == null) {
      throw Exception('Belum terhubung dengan anak');
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('kelas')
        .doc(_kelasId)
        .collection('postingan')
        .get();

    Map<String, List<Map<String, dynamic>>> postsPerMonth = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dateUpload = data['dateUpload'];
      final image = data['filePath'];

      if (dateUpload == null || image == null) continue;

      try {
        final date = DateFormat('dd MMMM yyyy', 'id_ID').parse(dateUpload);
        final monthKey = DateFormat('MMMM', 'id_ID').format(date);

        postsPerMonth.putIfAbsent(monthKey, () => []);
        postsPerMonth[monthKey]!.add({
          'date': date,
          'image': image,
          'dateUpload': dateUpload,
          'id': doc.id,
          'fileStoragePath': data['fileStoragePath'],
        });
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    Map<String, Map<String, dynamic>> latestPostPerMonth = {};
    postsPerMonth.forEach((month, posts) {
      posts.sort((a, b) => b['date'].compareTo(a['date']));
      latestPostPerMonth[month] = posts.first;
    });

    return latestPostPerMonth;
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data galeri',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUserData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: _fetchMonthsWithContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? {};

          final monthsInOrder = [
            'Januari',
            'Februari',
            'Maret',
            'April',
            'Mei',
            'Juni',
            'Juli',
            'Agustus',
            'September',
            'Oktober',
            'November',
            'Desember'
          ];

          final orderedData = Map.fromEntries(
            monthsInOrder
                .where((month) => data.containsKey(month))
                .map((month) => MapEntry(month, data[month])),
          );

          return GridView.builder(
            padding: EdgeInsets.only(
                top: height * 0.03, left: width * 0.04, right: width * 0.04),
            itemCount: orderedData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final month = orderedData.keys.elementAt(index);
              final monthData = orderedData[month];
              return buildMonthTile(
                context,
                monthData?['image'],
                month,
                monthData?['dateUpload'],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMonthTile(
    BuildContext context,
    String? imagePath,
    String label,
    String? dateUpload,
  ) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return GestureDetector(
      onTap: () {
        if (_kelasId == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailGaleriPage(
              kelasId: _kelasId!,
              bulan: label,
              date: dateUpload ?? "Tanggal tidak tersedia",
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: height * 0.12,
            width: width * 0.35,
            decoration: BoxDecoration(
              color: const Color(0xffF3FAFB),
              borderRadius: BorderRadius.circular(20),
              boxShadow: imagePath != null
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Image.asset(
                      'assets/icons/Galeri_bulan.png',
                      width: width * 0.5,
                      height: height * 0.5,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontVariations: [FontVariation('wght', 800)],
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
