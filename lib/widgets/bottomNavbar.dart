import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;
  const CustomBottomNavbar({
    required this.currentIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}
class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Color(0xff0066FF),
        currentIndex: _selectedIndex, // Use _selectedIndex here
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/beranda_select.png'),),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/galeri_select.png')),
            label: "Galeri",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/pesan_select.png')),
            label: "Pesan",
          ),
        ],
      ),
    );
  }
}
