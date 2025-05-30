import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
// import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String? userPhoto;
  final String userName;
  final String dateUpload;
  final String caption;
  final String filePath;
  final bool isGuru;
  final String kelasId;
  final String userId;

  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.postId,
    required this.userName,
    required this.dateUpload,
    required this.caption,
    required this.filePath,
    required this.isGuru,
    required this.kelasId,
    required this.userId,
    this.userPhoto,
    this.onDelete,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likeCount = 0;
  bool isLiking = false;

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
  }

  Future<void> fetchLikeStatus() async {
    final likesRef = FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('postingan')
        .doc(widget.postId)
        .collection('likes');

    final snapshot = await likesRef.get();
    final likedByUser = await likesRef.doc(widget.userId).get();

    if (!mounted) return;

    setState(() {
      likeCount = snapshot.size; // jumlah dokumen = jumlah like
      isLiked = likedByUser.exists;
    });
  }

  void toggleLike() async {
    if (isLiking) return; // kalau masih proses, jangan lanjut
    setState(() => isLiking = true);

    final likesCollection = FirebaseFirestore.instance
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('postingan')
        .doc(widget.postId)
        .collection('likes');

    final userLikeDoc = likesCollection.doc(widget.userId);
    final docSnapshot = await userLikeDoc.get();

    if (docSnapshot.exists) {
      await userLikeDoc.delete();
      setState(() {
        isLiked = false;
        likeCount = likeCount - 1;
      });
    } else {
      await userLikeDoc.set({'likedAt': FieldValue.serverTimestamp()});
      setState(() {
        isLiked = true;
        likeCount = likeCount + 1;
      });
    }

    setState(() => isLiking = false); // proses selesai
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return GestureDetector(
      onLongPress: () {
        if (widget.isGuru) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Apakah Anda yakin ingin menghapus cerita?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontVariations: [FontVariation('wght', 800)],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xff0066FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (widget.onDelete != null) widget.onDelete!();
                          },
                          child: const Text(
                            "Ya",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontVariations: [FontVariation('wght', 800)],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Tidak",
                            style: TextStyle(
                              color: Color(0xff0066FF),
                              fontSize: 18,
                              fontVariations: [FontVariation('wght', 800)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cerita",
                style: TextStyle(
                  fontSize: 20,
                  fontVariations: [FontVariation('wght', 800)],
                ),
              ),
              const SizedBox(height: 20),
              _uploader(),
              const SizedBox(height: 20),
              _mediaWidget(widget.filePath),
              const SizedBox(height: 15),
              _postAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: (widget.userPhoto != null &&
                  widget.userPhoto!.isNotEmpty)
              ? NetworkImage(widget.userPhoto!)
              : const AssetImage('assets/images/Bu_cindy.png') as ImageProvider,
          radius: 20,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName,
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
              ),
            ),
            Text(
              widget.dateUpload,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mediaWidget(String path) {
    bool isVideo = path.toLowerCase().endsWith('.mp4');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? Container(
                    color: Colors.black12,
                    child: Center(
                      child: Icon(Icons.videocam_off,
                          size: 40, color: Colors.grey),
                    ),
                  )
                : Image.network(
                    path,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.caption,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _postAction() {
    return Row(
      children: [
        GestureDetector(
          onTap: toggleLike,
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.black,
            size: 32,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          likeCount > 0 ? "$likeCount Suka" : "Suka",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
