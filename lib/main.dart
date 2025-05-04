import 'package:flutter/material.dart';
import 'package:littlesteps/pages/role_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // await Supabase.initialize(
  //   url: 'https://rsftbavuwvfqmdedqsdb.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJzZnRiYXZ1d3ZmcW1kZWRxc2RiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxMzQyMDIsImV4cCI6MjA2MDcxMDIwMn0.YSmRF4VmQ_b4k8gBBL7CCOWKFZNPyGfGIVgom0ReZ28',
  // );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: Scaffold(
        body: Center(child: RolePage(),),
      )
    );
  }
}

