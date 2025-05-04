import 'package:flutter/material.dart';
import 'package:littlesteps/utils/device_dimension.dart';
import 'package:littlesteps/widgets/bublechat.dart';

class RoomChatPage extends StatelessWidget {
    final bool isAnounce; 
    final List<Map<String, dynamic>> chats;
    const RoomChatPage({Key? key, required this.isAnounce, required this.chats}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final height = DeviceDimensions.height(context);
        return Scaffold(
            appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
                Icons.arrow_back,
                size: 36,
            ),
            ),
            title: Row(
            children: [
                const SizedBox(width: 15),
                if (!isAnounce)
                Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/images/Bu_rani.png"),
                    )
                )
                else
                const SizedBox(width: 20),
                Text(
                isAnounce ? "Pengumuman Kelas" : "Bu Rani",
                style: const TextStyle(
                fontVariations: [FontVariation('wght', 800)],
                    fontSize: 18,
                ),
                ),
            ],
            ),
        ),

        body: Column(
            children: [
            Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "Hari ini",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff8A9099),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            ),
            ),
            Expanded(
                child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                    final chat = chats[index];
                    return BubbleChat(
                    message: chat['message'],
                    isSender: chat['isSender'],
                    imageUrl: chat['imageUrl'], 
                    time: chat['time'],
                    );
                },
                ),
            ), 
            Container(
                height: height * 0.1,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: isAnounce
                ? const Center(
                        child: Text(
                        "Hanya guru di sekolah Anda yang dapat mengirim pengumuman",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff8A9099),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                        ),
                    ) 
                    : Row(
                        children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.add),),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF7F7FC),
                                hintText: 'Tulis pesan Anda disini...',
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            ),
                        ),
                        IconButton(onPressed: () {}, icon: ImageIcon(AssetImage('assets/icons/Kirim_pesan.png'), color: Color(0xff0066FF)),
                        )
                        ],
                    )
            )
            ],
        ),
        );
    }
}
