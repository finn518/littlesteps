import 'dart:io';
import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomDrawer extends StatefulWidget {
  final String namaUser;
  final String? fotoPath;
  final List<Map<String, dynamic>> menuItems;

  CustomDrawer({
    super.key,
    required this.namaUser,
    required this.menuItems,
      this.fotoPath
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.075, vertical: height * 0.01),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff53B1FD),
                  radius: 22,
                  child: CircleAvatar(
                    backgroundImage: widget.fotoPath != null
                        ? (widget.fotoPath!.startsWith('http')
                            ? NetworkImage(widget.fotoPath!)
                            : FileImage(File(widget.fotoPath!))
                                as ImageProvider)
                        : AssetImage('assets/images/Bu_mira.png')
                            as ImageProvider,
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.namaUser,
                  style: const TextStyle(
                    fontSize: 16,
                    fontVariations: [FontVariation('wght', 800)],
                  ),
                ),
              ],
            ),
          ),
          ...widget.menuItems.map((item) => ListTile(
                hoverColor: Colors.white70,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: item['onTap'],
              )),
        ],
      ),
    );
  }
}
