import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/custombutton.dart';
import 'package:littlesteps/widgets/customtextfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final nomerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = DeviceDimensions.width(context);
    final height = DeviceDimensions.height(context);
    return Scaffold(
     appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: 36,
            )),
            title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w800),),
            centerTitle: true,
            backgroundColor: Color(0xffB2DDFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           editprofil(width),
           Container(
            padding: EdgeInsets.symmetric(
                  horizontal: width * 0.12, vertical: height * 0.02),
             child: Column(
              children: [
                CustomTextField(label: "Nama", controller: namaController),
                CustomTextField(label: "Email", controller: namaController),
                CustomTextField(label: "Nomor Telepon", controller: namaController),
                SizedBox(height: 30),
                CustomButton(label: "Edit Profile", onPressed: () {},)
              ],
             ),
           ),
          
          ],
        ),
      ),
    );
  }

  Widget editprofil(double width) {
    return Column(
      children: [
        SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -20,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bgprofil.png"))),
                      ),
                    ),
                    Positioned(
                      left: width * 0.32,
                      bottom: -40, 
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Color(0xff0066FF),
                            child: CircleAvatar(
                              radius: 65, //nanti dikecilin
                              backgroundImage: AssetImage("assets/images/Bu_mira.png"),
                            ),
                          ),
                          CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent, // Biar transparan
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/icons/Edit_profil.png',
                                fit: BoxFit.cover,
                                width: 50, // ukuran sesuai radius * 2
                                height: 50,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors
                                    .transparent, // biar button transparan
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    // Aksi saat ditekan
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                        ],
                      )
                    )
                  ],
                ),
               ),
               SizedBox(height: 80,)
      ],
    );
  }
}
