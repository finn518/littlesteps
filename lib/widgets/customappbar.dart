import 'package:flutter/material.dart';
import 'package:littlesteps/pages/notifikasiPage.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String role;
  const CustomAppbar({super.key, required this.role});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
                    backgroundImage: AssetImage('assets/images/Bu_cindy.png'),
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
                  size: 40,
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
              AssetImage('assets/icons/Notifikasi.png'),
              size: 40,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotifikasiPage(role: role)));
            },
          ),
        ),
      ],
    );
  }
}
