import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:littlesteps/pages/notifikasiPage.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String role;
  CustomAppbar({super.key, required this.role});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  String? fotoPath;

  @override
  void initState() {
    super.initState();
    fetchFotoPath();
  }

  void fetchFotoPath() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()!.containsKey('fotoPath')) {
        final path = doc['fotoPath'];
        if (path != null && path != '') {
          setState(() {
            fotoPath = path;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff53B1FD),
                  radius: 20,
                  child: CircleAvatar(
                    backgroundImage: fotoPath != null
                        ? (fotoPath!.startsWith('http')
                            ? NetworkImage(fotoPath!)
                            : FileImage(File(fotoPath!)) as ImageProvider)
                        : AssetImage('assets/images/Bu_mira.png')
                            as ImageProvider,
                    radius: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                const ImageIcon(
                  AssetImage(
                    'assets/icons/Sidebar.png',
                  ),
                  size: 35,
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.03),
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/icons/notification.png'),
              size: 30,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotifikasiPage(role: widget.role)));
            },
          ),
        ),
      ],
    );
  }
}
