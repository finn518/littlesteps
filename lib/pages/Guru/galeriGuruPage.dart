import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/pages/Guru/uploadGaleri.dart';
import 'package:littlesteps/widgets/postcard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GaleriGuruPage extends StatefulWidget {
  final String kelasId;

  const GaleriGuruPage({super.key, required this.kelasId});

  @override
  State<GaleriGuruPage> createState() => _GaleriGuruPageState();
}

class _GaleriGuruPageState extends State<GaleriGuruPage> {
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    // Set default selected month to the current month
    _selectedMonth = DateFormat('MMMM', 'id_ID').format(DateTime.now());
  }

  Stream<Map<String, Map<String, dynamic>>> _getMonthsStream() {
    return FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('postingan')
        .where('filePath', isNotEqualTo: '')
        .snapshots()
        .map((snapshot) {
      Map<String, List<Map<String, dynamic>>> postsPerMonth = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final createdAt = data['createdAt'];
        final image = data['filePath'];

        if (createdAt == null || image == null) continue;

        try {
          final date = (createdAt as Timestamp).toDate();
          final monthKey = DateFormat('MMMM', 'id_ID').format(date);

          postsPerMonth.putIfAbsent(monthKey, () => []);
          postsPerMonth[monthKey]!.add({
            'date': date,
            'image': image,
            'dateUpload': data['dateUpload'] ?? '',
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
    });
  }

  Future<void> _deletePostingan(String docId, String fileStoragePath) async {
    try {
      await FirebaseFirestore.instance
          .collection('kelas')
          .doc(widget.kelasId)
          .collection('postingan')
          .doc(docId)
          .delete();

      await Supabase.instance.client.storage
          .from('postingan')
          .remove([fileStoragePath]);
      print('File berhasil dihapus dari Supabase: $fileStoragePath');
    } catch (e) {
      print('Gagal menghapus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            /// ================== MONTH TABS (STREAM) ==================
            StreamBuilder<Map<String, Map<String, dynamic>>>(
              stream: _getMonthsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: 120,
                    child: Center(child: Text('Belum ada postingan')),
                  );
                }

                final monthsData = snapshot.data!;
                final monthNames = monthsData.keys.toList()
                  ..sort((a, b) =>
                      _getMonthNumber(a).compareTo(_getMonthNumber(b)));

                return SizedBox(
                  height: 110,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: monthNames.map((month) {
                        final monthData = monthsData[month];
                        return _monthTab(
                          month,
                          monthData?['image'],
                          month == _selectedMonth,
                          () {
                            setState(() {
                              _selectedMonth = month;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            /// ================== POSTINGAN (STREAM) ==================
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('kelas')
                    .doc(widget.kelasId)
                    .collection('postingan')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada postingan'));
                  }

                  final filteredPosts = snapshot.data!.docs.where((doc) {
                    if (_selectedMonth == null) return true;

                    final data = doc.data() as Map<String, dynamic>;
                    final createdAt = data['createdAt'];
                    if (createdAt == null) return false;

                    try {
                      final date = (createdAt as Timestamp).toDate();
                      final monthStr = DateFormat('MMMM', 'id_ID').format(date);
                      return monthStr == _selectedMonth;
                    } catch (_) {
                      return false;
                    }
                  }).toList();

                  if (filteredPosts.isEmpty) {
                    return Center(child: Text('Tidak ada postingan bulan ini'));
                  }

                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: filteredPosts.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return PostCard(
                        postId: data['id'],
                        userName: data['userName'] ?? 'Anonim',
                        dateUpload: data['dateUpload'] ?? '',
                        caption: data['caption'] ?? '',
                        filePath: data['filePath'] ?? '',
                        likes: data['likes'] ?? 0,
                        isGuru: true,
                        onDelete: () => _deletePostingan(
                          data['id'],
                          data['fileStoragePath'] ?? '',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4285F4),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadGaleri(kelasId: widget.kelasId),
            ),
          ).then((_) {
            // Refresh data setelah kembali dari upload
            setState(() {});
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _monthTab(
    String label,
    String? imageUrl,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? Colors.blue : Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null
                    ? ColorFiltered(
                        colorFilter: isSelected
                            ? ColorFilter.mode(
                                Colors.transparent, BlendMode.multiply)
                            : ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 40),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontVariations: [FontVariation('wght', 800)],
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getMonthNumber(String month) {
    switch (month) {
      case 'Januari':
        return 1;
      case 'Februari':
        return 2;
      case 'Maret':
        return 3;
      case 'April':
        return 4;
      case 'Mei':
        return 5;
      case 'Juni':
        return 6;
      case 'Juli':
        return 7;
      case 'Agustus':
        return 8;
      case 'September':
        return 9;
      case 'Oktober':
        return 10;
      case 'November':
        return 11;
      case 'Desember':
        return 12;
      default:
        return 0;
    }
  }
}
