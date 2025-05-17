import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:littlesteps/pages/OrangTua/downloadimage_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class DetailGaleriPage extends StatefulWidget {
  final String kelasId;
  final String bulan;
  final String date;

  const DetailGaleriPage(
      {super.key,
      required this.kelasId,
      required this.bulan,
      required this.date});

  @override
  State<DetailGaleriPage> createState() => _DetailGaleriPageState();
}

class _DetailGaleriPageState extends State<DetailGaleriPage> {
  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 36),
        ),
        title: Text(
          widget.bulan,
          style: TextStyle(
              fontVariations: [FontVariation('wght', 800)], fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kelas')
            .doc(widget.kelasId)
            .collection('postingan')
            .where('filePath', isNotEqualTo: '')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada media untuk bulan ini"));
          }

          // Filter dokumen berdasarkan bulan yang dipilih
          final filteredDocs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final dateUpload = data['dateUpload']?.toString() ?? '';
            return dateUpload
                .toLowerCase()
                .contains(widget.bulan.toLowerCase());
          }).toList();

          if (filteredDocs.isEmpty) {
            return const Center(child: Text("Tidak ada media untuk bulan ini"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.01),
              itemCount: filteredDocs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final data = filteredDocs[index].data() as Map<String, dynamic>;
                final filePath = data['filePath'] ?? '';
                final isVideo = filePath.toLowerCase().endsWith('.mp4') ||
                    filePath.toLowerCase().endsWith('.mov');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DonwloadImagePage(
                                url: filePath, date: widget.date)));
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: !isVideo
                              ? DecorationImage(
                                  image: NetworkImage(filePath),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: isVideo ? Colors.black26 : null,
                        ),
                        child: isVideo
                            ? const Center(
                                child: Icon(Icons.play_circle_fill,
                                    color: Colors.white, size: 40),
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
