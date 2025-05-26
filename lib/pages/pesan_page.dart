import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlesteps/pages/roomchat_page.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/utils/encryption_helper.dart';

class PesanPage extends StatefulWidget {
  final String role;
  final String kelasId;
  const PesanPage({super.key, required this.role, required this.kelasId});

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late String currentUserId;
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = auth.currentUser!.uid;
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

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
  void _navigateToRoomChat(
      {required bool isAnounce, required Map<String, dynamic>? penerima}) {
    if (isAnounce) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomChatPage(
            isAnounce: true,
            kelasId: widget.kelasId,
            role: widget.role,
          ),
        ),
      );
    } else {
      if (penerima != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomChatPage(
              isAnounce: false,
              kelasId: widget.kelasId,
              role: widget.role,
              user: penerima,
            ),
          ),
        );
      }
    }
  }

  void _showSelectReceiverDialog() async {
    final List<Map<String, dynamic>> semuaUserData = [];
    final guruSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'Guru')
        .get();
    semuaUserData.addAll(guruSnapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    }));

    // Kalo yg ngirim Orang Tua atau Guru, jadinya ada orang tua dari kelas yang sama
    if (widget.role == "Orang Tua" || widget.role == 'Guru') {
      final ortuSnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'Orang Tua')
          .where('kelasId', isEqualTo: widget.kelasId)
          .get();
      semuaUserData.addAll(ortuSnapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }));
    }

    final filteredUsers =
        semuaUserData.where((u) => u['uid'] != currentUserId).toList();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Penerima',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...filteredUsers.map((userMap) {
                final fotoPath =
                    userMap['fotoPath'] ?? 'assets/images/Bu_cindy.png';
                final imageProvider = fotoPath.startsWith('http')
                    ? NetworkImage(fotoPath)
                    : AssetImage(fotoPath) as ImageProvider;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 24,
                  ),
                  title: Text(
                    '${userMap['sapaan'] != null && userMap['sapaan'].toString().isNotEmpty ? '${userMap['sapaan']} ' : ''}${userMap['name']}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  subtitle: Text(
                    userMap['role'] ?? 'No Role',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToRoomChat(
                      isAnounce: false,
                      penerima: userMap,
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  bool isUserInRoomId(String roomId, String uid) {
    final parts = roomId.split('_');
    return parts.contains(uid);
  }

  void showDeleteChatDialog(
      BuildContext context, String kelasId, String roomId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah Anda yakin ingin menghapus chat ini beserta seluruh isinya?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Ya
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xff0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await deleteChatRoom(kelasId, roomId);
                    },
                    child: const Text("Ya",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 18)),
                  ),
                  const SizedBox(width: 16),
                  // Tombol Tidak
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () => Navigator.pop(context), // Tutup dialog
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
        );
      },
    );
  }

  Future<void> deleteChatRoom(String kelasId, String roomId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final pesanCollection = firestore
          .collection('kelas')
          .doc(kelasId)
          .collection('chatPribadi')
          .doc(roomId)
          .collection('pesan');

      final pesanSnapshot = await pesanCollection.get();
      final batch = firestore.batch();

      for (final doc in pesanSnapshot.docs) {
        batch.delete(doc.reference);
      }
      final roomDocRef = firestore
          .collection('kelas')
          .doc(kelasId)
          .collection('chatPribadi')
          .doc(roomId);
      batch.delete(roomDocRef);

      await batch.commit();

      debugPrint("Chat room dan seluruh pesannya berhasil dihapus.");
    } catch (e) {
      debugPrint("Gagal menghapus chat room: $e");
    }
  }

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchText = value.toLowerCase();
      });
    });
  }

  List<Map<String, dynamic>> _filterChatRooms(
      List<Map<String, dynamic>> rooms, String searchQuery) {
    if (searchQuery.isEmpty) return rooms;

    return rooms.where((room) {
      final user = room['user'] as Map<String, dynamic>;
      final name = '${user['sapaan']} ${user['name']}'.toLowerCase();

      // Gabungkan semua pesan dalam room
      final allMessages = room['messages'] as List;
      final messageTexts = allMessages
          .map((msg) => _handleMessage(msg['isiPesan']).toLowerCase())
          .toList();

      // Cek apakah nama atau pesan mengandung searchQuery
      return name.contains(searchQuery) ||
          messageTexts.any((text) => text.contains(searchQuery));
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, vertical: height * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: double.infinity,
                height: width * 0.12,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchText = '';
                        });
                      },
                      icon: ImageIcon(AssetImage('assets/icons/Cari.png')),
                    ),
                    hintText: 'Cari percakapan...',
                  ),
                ),
              ),
            ),

            // Pengumuman
            GestureDetector(
              onTap: () => _navigateToRoomChat(isAnounce: true, penerima: null),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xFFFEF9E4),
                margin:
                    EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      ImageIcon(AssetImage('assets/icons/Pengumuman.png'),
                          size: 36),
                      SizedBox(width: 20),
                      Text("Pengumuman",
                          style: TextStyle(
                              fontVariations: [FontVariation('wght', 800)],
                              fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),

            // Ini kalo chat udh pernah ada
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('kelas')
                  .doc(widget.kelasId)
                  .collection('chatPribadi')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox();

                final docs = snapshot.data!.docs.where((doc) {
                  final parts = doc.id.split('_');
                  return parts.contains(currentUserId);
                });

                final seen = <String>{};
                final uniqueDocs = <QueryDocumentSnapshot>[];

                for (var doc in docs) {
                  final parts = doc.id.split('_')..sort();
                  final roomKey = parts.join('_');

                  if (!seen.contains(roomKey)) {
                    seen.add(roomKey);
                    uniqueDocs.add(doc);
                  }
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.wait(uniqueDocs.map((doc) async {
                    final roomId = doc.id;
                    final parts = roomId.split('_');
                    final partnerId =
                        parts.firstWhere((id) => id != currentUserId);

                    final userSnap = await firestore
                        .collection('users')
                        .doc(partnerId)
                        .get();
                    final userData = userSnap.data() ?? {};
                    userData['uid'] = userSnap.id;

                    // Ambil semua pesan di dalam room
                    final pesanSnap = await firestore
                        .collection('kelas')
                        .doc(widget.kelasId)
                        .collection('chatPribadi')
                        .doc(roomId)
                        .collection('pesan')
                        .orderBy('timestamp')
                        .get();

                    final messages =
                        pesanSnap.docs.map((doc) => doc.data()).toList();

                    // Ambil timestamp pesan terakhir
                    final lastTimestamp = pesanSnap.docs.isNotEmpty
                        ? pesanSnap.docs.last['timestamp']
                        : null;

                    return {
                      'user': userData,
                      'roomId': roomId,
                      'messages': messages,
                      'lastTimestamp': lastTimestamp,
                    };
                  })),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox();

                    final sortedRooms = snapshot.data!;
                    sortedRooms.sort((a, b) {
                      final aTime = a['lastTimestamp'] as Timestamp?;
                      final bTime = b['lastTimestamp'] as Timestamp?;
                      if (aTime == null && bTime == null) return 0;
                      if (aTime == null) return 1;
                      if (bTime == null) return -1;
                      return bTime.compareTo(aTime);
                    });

                    final filteredRooms =
                        _filterChatRooms(sortedRooms, searchText);

                    if (filteredRooms.isEmpty && searchText.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Tidak ditemukan percakapan dengan kata kunci "$searchText"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: filteredRooms.map((data) {
                        final user = data['user'];
                        final messages = data['messages'] as List;

                        // Ambil timestamp dari pesan terakhir
                        final lastTimestamp =
                            data['lastTimestamp'] as Timestamp?;
                        final formattedTime = lastTimestamp != null
                            ? DateFormat('HH:mm').format(lastTimestamp.toDate())
                            : '';

                        // Ambil pesan terakhir atau pesan pertama untuk ditampilkan
                        final lastMessage = _handleMessage(messages.isNotEmpty
                            ? messages.last['isiPesan']
                            : '');

                        return bubblePesan(
                          '${user['sapaan']} ${user['name']}',
                          lastMessage,
                          formattedTime, // Tampilkan waktu yang sudah diformat
                          () => _navigateToRoomChat(
                            isAnounce: false,
                            penerima: user,
                          ),
                          user['fotoPath'] ?? 'assets/images/Bu_rani.png',
                          context,
                        );
                      }).toList(),
                    );
                  },
                );
              },
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: _showSelectReceiverDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget bubblePesan(
    String name,
    String pesan,
    String waktu,
    VoidCallback onTap,
    String imagePath,
    BuildContext context, {
    VoidCallback? onLongPress,
  }) {
    final width = DeviceDimensions.width(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: imagePath.startsWith('http')
                    ? NetworkImage(imagePath)
                    : AssetImage(imagePath)
                        as ImageProvider, // Pastikan gambar ada di path ini
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          waktu,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      pesan,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
