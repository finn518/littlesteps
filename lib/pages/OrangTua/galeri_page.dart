import 'package:flutter/material.dart';


class GaleriPage extends StatelessWidget {
  const GaleriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      childrenDelegate: SliverChildListDelegate.fixed(
        [
          buildMonthTile('assets/images/GAMBAR_UPLOAD_FEBRUARI.png', 'Januari'),
          buildMonthTile('assets/images/GAMBAR_UPLOAD_FEBRUARI.png', 'Februari'),
          buildMonthTile(null, 'Maret'),
          buildMonthTile(null, 'April'),
          buildMonthTile(null, 'Mei'),
          buildMonthTile(null, 'Juni'),
        ],
      ),
    );

  }

  Widget buildMonthTile(String? imagePath, String label) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xffF3FAFB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: imagePath != null
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 8),
                    ),
                  ]
                : [],
            image: imagePath != null
                ? DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imagePath == null
              ? ImageIcon(AssetImage('assets/icons/Galeri_bulan.png'))
              : null,
        ),
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      ],
    );
  }

}