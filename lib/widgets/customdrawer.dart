import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomDrawer extends StatelessWidget {
  final String namaUser;
  final List<Map<String, dynamic>> menuItems;

  const CustomDrawer({
    super.key,
    required this.namaUser,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.075,
              vertical: height * 0.01
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff53B1FD),
                  radius: 22,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Bu_cindy.png'),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  namaUser,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) => ListTile(
                hoverColor: Colors.white70,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
