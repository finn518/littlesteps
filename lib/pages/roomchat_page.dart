import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/bublechat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomChatPage extends StatefulWidget {
  final bool isAnounce;
  final String kelasId;
  final String role;
  // final List<Map<String, dynamic>> chats;
  const RoomChatPage(
      {Key? key,
      required this.isAnounce,
      required this.kelasId,
      required this.role})
      : super(key: key);

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController pesan = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  File? selectedImage;
  bool isSending = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> uploadImages() async {
    if (selectedImage == null) return null;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'images/$fileName.jpg';

    await Supabase.instance.client.storage
        .from('pesan')
        .upload(path, selectedImage!);

    final publicUrl =
        Supabase.instance.client.storage.from('pesan').getPublicUrl(path);

    return publicUrl;
  }

  Future<void> _sendPengumuman() async {
    final text = pesan.text.trim();
    final filePath = await uploadImages();

    if (text.isEmpty && filePath == null) return;

    final docRef = firestore
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('pengumuman')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'kelasId': widget.kelasId,
      'isiPesan': text,
      'filePath': filePath,
      'pengirimId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    pesan.clear();
    setState(() {
      selectedImage = null;
    });
  }

  Widget selectedImagePreview() {
    if (selectedImage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              selectedImage!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => setState(() => selectedImage = null),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ))
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Hari ini';
    } else if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day - 1) {
      return 'Kemarin';
    } else {
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = DeviceDimensions.height(context);
    final isTeacher = widget.role == "Guru";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            size: 36,
          ),
        ),
        title: Row(
          children: [
            const SizedBox(width: 15),
            if (!widget.isAnounce)
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/Bu_rani.png"),
                  ))
            else
              const SizedBox(width: 20),
            Text(
              widget.isAnounce ? "Pengumuman Kelas" : "Bu Rani",
              style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('kelas')
                    .doc(widget.kelasId)
                    .collection(widget.isAnounce ? 'pengumuman' : 'chat')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("Belum ada pengumuman"),
                    );
                  }
                  final chats = docs.reversed.toList();

                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final chatDateTimestamp =
                            chat['timestamp'] as Timestamp?;
                        final chatDate =
                            chatDateTimestamp?.toDate() ?? DateTime.now();

                        bool showDateHeader = false;
                        if (index == 0) {
                          showDateHeader = true;
                        } else {
                          final prevChatTimestamp =
                              chats[index - 1]['timestamp'] as Timestamp?;
                          final prevChatDate =
                              prevChatTimestamp?.toDate() ?? DateTime.now();
                          if (chatDate.day != prevChatDate.day ||
                              chatDate.month != prevChatDate.month ||
                              chatDate.year != prevChatDate.year) {
                            showDateHeader = true;
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showDateHeader)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: Text(
                                    formatDate(chatDate),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            BubbleChat(
                              message: chat['isiPesan'] ?? '',
                              isSender: isTeacher
                                  ? chat['pengirimId'] == userId
                                  : chat['pengirimId'] == userId,
                              imageUrl: chat['filePath'],
                              time:
                                  DateFormat('HH:mm', 'id_ID').format(chatDate),
                            )
                          ],
                        );
                      });
                })),
        if (selectedImage != null) selectedImagePreview(),
        Container(
            height: height * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: widget.isAnounce && !isTeacher
                ? const Center(
                    child: Text(
                      "Hanya guru di sekolah Anda yang dapat mengirim pengumuman",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff8A9099),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Row(
                    children: [
                      IconButton(
                        onPressed: pickImage,
                        icon: const Icon(Icons.add),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        controller: pesan,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF7F7FC),
                            hintText: 'Tulis pesan Anda disini...',
                            hintStyle: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                      )),
                      IconButton(
                          onPressed: isSending
                              ? null
                              : () async {
                                  if (pesan.text.trim().isEmpty &&
                                      selectedImage == null) return;
                                  setState(() => isSending = true);

                                  if (widget.isAnounce) {
                                    if (!isTeacher) {
                                      setState(() => isSending = false);
                                      return;
                                    }
                                    await _sendPengumuman();
                                  } else {
                                    // await _sendChat();
                                  }

                                  setState(() => isSending = false);
                                },
                          icon: isSending
                              ? const CircularProgressIndicator()
                              : ImageIcon(
                                  const AssetImage(
                                      'assets/icons/Kirim_pesan.png'),
                                  color: const Color(0xff0066ff),
                                ))
                    ],
                  ))
      ]),
    );
  }
}
