import 'package:b2bmobile/Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/responsive/mobile_screen_layout.dart';
import 'package:b2bmobile/responsive/responsive_layout_screen.dart';
import 'package:b2bmobile/responsive/web_screen_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'Screens/authenticate/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBhdJBPEgapkYbbCqF1TH-TdQUOb6FgUTA',
        appId: '1:749632425380:web:d0cbbe5cd242d2267bc531',
        messagingSenderId: '749632425380',
        projectId: 'b2bmobile-b2ed8',
        storageBucket: 'b2bmobile-b2ed8.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Back2Black Mobile',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: const LoginScreen(),
    );
  }
}
