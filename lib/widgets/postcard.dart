import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
// import 'package:video_player/video_player.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String? userPhoto;
  final String userName;
  final String dateUpload;
  final String caption;
  final String filePath;
  final int likes;
  final bool isGuru;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.postId,
    required this.userName,
    required this.dateUpload,
    required this.caption,
    required this.filePath,
    required this.likes,
    required this.isGuru,
    this.userPhoto,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return GestureDetector(
      onLongPress: () {
        if (isGuru) {
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
                            if (onDelete != null) onDelete!();
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
              _mediaWidget(filePath),
              const SizedBox(height: 15),
              _postAction(likes),
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
          backgroundImage: (userPhoto != null && userPhoto!.isNotEmpty)
              ? NetworkImage(userPhoto!)
              : const AssetImage('assets/images/Bu_cindy.png') as ImageProvider,
          radius: 20,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
              ),
            ),
            Text(
              dateUpload,
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
          caption,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Widget _mediaWidget(String path) {
  //   bool isVideo = path.toLowerCase().endsWith('.mp4');
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AspectRatio(
  //         aspectRatio: 1,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: isVideo
  //               ? _VideoPlayerWidget(videoUrl: path)
  //               : Image.network(
  //                   path,
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (_, __, ___) =>
  //                       const Icon(Icons.broken_image),
  //                 ),
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       Text(
  //         caption,
  //         style: const TextStyle(
  //           fontFamily: "Poppins",
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _postAction(int totalLike) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Aksi tombol like
          },
          child: const Icon(Icons.favorite_border_outlined, size: 32),
        ),
        const SizedBox(width: 10),
        Text(
          totalLike > 0 ? "$totalLike Suka" : "Suka",
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

// class _VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const _VideoPlayerWidget({Key? key, required this.videoUrl})
//       : super(key: key);

//   @override
//   State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _initialized = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {
//           _initialized = true;
//         });
//         _controller.setLooping(true);
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       _showControls = true;
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() {
//             _showControls = false;
//           });
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _initialized
//         ? GestureDetector(
//             onTap: _togglePlayPause,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 VideoPlayer(_controller),
//                 AnimatedOpacity(
//                   opacity: _showControls ? 1.0 : 0.0,
//                   duration: const Duration(milliseconds: 300),
//                   child: Container(
//                     color: Colors.black45,
//                     child: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause_circle
//                           : Icons.play_circle,
//                       color: Colors.white,
//                       size: 64,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
