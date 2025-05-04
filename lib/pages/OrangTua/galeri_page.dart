import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';

class GaleriPage extends StatelessWidget {
  const GaleriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Diubah untuk proporsi yang lebih baik
      ),
      padding: EdgeInsets.only(
          top: height * 0.03, left: width * 0.04, right: width * 0.04),
      childrenDelegate: SliverChildListDelegate.fixed([
        buildMonthTile(
            context, 'assets/images/GAMBAR_UPLOAD_FEBRUARI.png', 'Januari'),
        buildMonthTile(
            context, 'assets/images/GAMBAR_UPLOAD_FEBRUARI.png', 'Februari'),
        buildMonthTile(context, null, 'Maret'),
        buildMonthTile(context, null, 'April'),
        buildMonthTile(context, null, 'Mei'),
        buildMonthTile(context, null, 'Juni'),
      ]),
    );
  }

  Widget buildMonthTile(BuildContext context, String? imagePath, String label) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Column(
      children: [
        Container(
          height: height * 0.12,
          width: width * 0.35,
          decoration: BoxDecoration(
            color: const Color(0xffF3FAFB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: imagePath != null
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Image.asset(
                    'assets/icons/Galeri_bulan.png',
                    width: width * 0.5,
                    height: height * 0.5,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontVariations: [FontVariation('wght', 800)],
            fontSize: 28, // Ukuran font lebih kecil
          ),
        ),
      ],
    );
  }
}
