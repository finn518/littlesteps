// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:littlesteps/pages/splash_screen.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('id_ID', null);
  // await FirebaseMessaging.instance.requestPermission();
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   if (message.notification != null) {
  //     // Tampilkan notifikasi lokal
  //     // Atau pakai plugin seperti flutter_local_notifications
  //     print('Notif masuk: ${message.notification!.title}');
  //   }
  // });

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Inter',
            scaffoldBackgroundColor: Color(0xffF3FAFB),
            appBarTheme: AppBarTheme(backgroundColor: Color(0xffF3FAFB))),
        home: SplashScreen());
  }
}

        // body: Center(child: RolePage(),),

