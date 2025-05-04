import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // menjaga posisi tetap
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: const Color(0xff0066FF),
          unselectedItemColor: Colors.black,
          selectedIconTheme: const IconThemeData(size: 24),
          unselectedIconTheme: const IconThemeData(size: 24),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  _selectedIndex == 0
                      ? 'assets/icons/beranda_select.png'
                      : 'assets/icons/Beranda_abu.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0
                      ? null
                      : Colors.black, // warna saat belum dipilih
                ),
              ),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: ImageIcon(AssetImage('assets/icons/galeri_select.png')),
              ),
              label: "Galeri",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: ImageIcon(AssetImage('assets/icons/pesan_select.png')),
              ),
              label: "Pesan",
            ),
          ],
        ),
      ),
    );
  }


}
