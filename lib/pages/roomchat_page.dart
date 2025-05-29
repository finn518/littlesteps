import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/utils/encryption_helper.dart';
import 'package:littlesteps/widgets/bublechat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomChatPage extends StatefulWidget {
  final bool isAnounce;
  final String? kelasId;
  final String role;
  final Map<String, dynamic>? user;

  const RoomChatPage(
      {Key? key,
      required this.isAnounce,
      this.kelasId,
      required this.role,
      this.user})
      : super(key: key);

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController pesan = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? userId = fb_auth.FirebaseAuth.instance.currentUser?.uid;
  File? selectedImage;
  bool isSending = false;

  String _handleMessage(dynamic message) {
    if (message == null) return '';

    try {
      if (EncryptionHelper.isEncrypted(message)) {
        return EncryptionHelper.decryptText(message as String);
      }
      return message.toString();
    } catch (e) {
      debugPrint('Error decrypting message: $e');
      return message.toString(); // Fallback ke pesan asli
    }
  }

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

    final encryptedText =
        text.isNotEmpty ? EncryptionHelper.encryptText(text) : null;

    final docRef = firestore
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('pengumuman')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'kelasId': widget.kelasId,
      'isiPesan': encryptedText,
      'filePath': filePath,
      'pengirimId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Ambil data user pengirim (nama + foto)
    final pengirimSnapshot =
        await firestore.collection('users').doc(userId).get();
    final pengirimData = pengirimSnapshot.data();

    final sapaan = pengirimData?['sapaan'];
    final namaLengkap = pengirimData?['name'] ?? 'Pengirim';
    final namaUser = sapaan != null ? "$sapaan $namaLengkap" : namaLengkap;
    final fotoUser = pengirimData?['fotoPath'] ?? '';

    // Ambil semua user dengan role 'Orang Tua' yang ada di kelas ini
    final orangTuaSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'Orang Tua')
        .where('kelasId', isEqualTo: widget.kelasId)
        .get();

    for (final doc in orangTuaSnapshot.docs) {
      final orangTuaId = doc.id;
      await firestore
          .collection('users')
          .doc(orangTuaId)
          .collection('notifikasi')
          .add({
        'fotoUser': fotoUser,
        'pesan': '$namaUser telah membuat pengumuman baru',
        'waktu': FieldValue.serverTimestamp(),
      });
    }

    pesan.clear();
    setState(() {
      selectedImage = null;
    });
  }

  String getChatRoomId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> _sendChatPribadi() async {
    final text = pesan.text.trim();
    final filePath = await uploadImages();
    if (text.isEmpty && filePath == null) return;

    final encryptedText =
        text.isNotEmpty ? EncryptionHelper.encryptText(text) : null;

    final penerimaId = widget.user?['uid'];
    final senderId = userId!;
    final chatRoomId = getChatRoomId(senderId, penerimaId!);

    final docRef = firestore
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('chatPribadi')
        .doc(chatRoomId)
        .collection('pesan')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'isiPesan': encryptedText,
      'filePath': filePath,
      'pengirimId': senderId,
      'penerimaId': penerimaId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('kelas')
        .doc(widget.kelasId)
        .collection('chatPribadi')
        .doc(chatRoomId)
        .set({
      'lastUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 🔍 Ambil data pengirim
    final pengirimSnapshot =
        await firestore.collection('users').doc(senderId).get();
    final pengirimData = pengirimSnapshot.data();

    final namaPengirim =
        "${pengirimData?['sapaan']} ${pengirimData?['name']}" ??
            pengirimData?['name'];
    final fotoPengirim = pengirimData?['fotoPath'] ?? '';

    // 🔔 Tambahkan notifikasi ke penerima
    await firestore
        .collection('users')
        .doc(penerimaId)
        .collection('notifikasi')
        .add({
      'fotoUser': fotoPengirim,
      'pesan': 'Ada chat baru dari $namaPengirim',
      'waktu': FieldValue.serverTimestamp(),
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

  void showDeleteChatDialog(
      BuildContext context, String kelasId, String chatRoomId, String pesanId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Apakah Anda yakin ingin menghapus pesan ini?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xff0066FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await deleteChatMessage(kelasId, chatRoomId, pesanId);
                  },
                  child: const Text("Ya",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 18)),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tidak",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xff0066FF),
                          fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteChatMessage(
      String kelasId, String chatRoomId, String pesanId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      if (widget.isAnounce) {
        await firestore
            .collection('kelas')
            .doc(kelasId)
            .collection('pengumuman')
            .doc(pesanId)
            .delete();
      } else {
        await firestore
            .collection('kelas')
            .doc(kelasId)
            .collection('chatPribadi')
            .doc(chatRoomId)
            .collection('pesan')
            .doc(pesanId)
            .delete();
      }
      debugPrint("Pesan berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus pesan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = DeviceDimensions.height(context);
    final isTeacher = widget.role == "Guru";
    final chatStream = widget.isAnounce
        ? firestore
            .collection('kelas')
            .doc(widget.kelasId)
            .collection('pengumuman')
            .orderBy('timestamp', descending: true)
            .snapshots()
        : firestore
            .collection('kelas')
            .doc(widget.kelasId)
            .collection('chatPribadi')
            .doc(getChatRoomId(userId!, widget.user!['uid']))
            .collection('pesan')
            .orderBy('timestamp', descending: true)
            .snapshots();

    if (widget.kelasId!.isEmpty && !isTeacher) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 36,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Anda belum terhubung dengan kelas anak",
            style: TextStyle(
                fontSize: 16, fontVariations: [FontVariation('wght', 800)]),
          ),
        ),
      );
    }
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
                    backgroundImage: widget.user?['fotoPath'] != null
                        ? NetworkImage(widget.user!['fotoPath']!)
                        : const AssetImage('assets/images/Bu_Rani.png')
                            as ImageProvider,
                  ))
            else
              const SizedBox(width: 20),
            Text(
              widget.isAnounce
                  ? "Pengumuman Kelas"
                  : "${widget.user?['sapaan']} ${widget.user?['name']}",
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
                stream: chatStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Terjadi kesalahan'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Belum ada pesan'),
                    );
                  }

                  return ListView.builder(
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final pengirimId = data['pengirimId'] ?? '';
                        final isMe =
                            widget.isAnounce ? isTeacher : pengirimId == userId;
                        final chatTimestamp = data['timestamp'] as Timestamp?;
                        final chatDate =
                            chatTimestamp?.toDate() ?? DateTime.now();

                        bool showDateHeader = false;
                        if (index == docs.length - 1) {
                          showDateHeader = true;
                        } else {
                          final nextData =
                              docs[index + 1].data() as Map<String, dynamic>;
                          final nextTimestamp =
                              nextData['timestamp'] as Timestamp?;
                          final nextDate =
                              nextTimestamp?.toDate() ?? DateTime.now();

                          if (chatDate.day != nextDate.day ||
                              chatDate.month != nextDate.month ||
                              chatDate.year != nextDate.year) {
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
                              message: _handleMessage(data['isiPesan']),
                              isSender: isMe,
                              imageUrl: data['filePath'],
                              time:
                                  DateFormat('HH:mm', 'id_ID').format(chatDate),
                              onLongPress: isMe
                                  ? () {
                                      if (widget.isAnounce) {
                                        showDeleteChatDialog(
                                          context,
                                          widget.kelasId!,
                                          '',
                                          docs[index].id,
                                        );
                                      } else {
                                        showDeleteChatDialog(
                                          context,
                                          widget.kelasId!,
                                          getChatRoomId(
                                              userId!, widget.user!['uid']),
                                          docs[index].id,
                                        );
                                      }
                                    }
                                  : null,
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
                                    await _sendChatPribadi();
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
