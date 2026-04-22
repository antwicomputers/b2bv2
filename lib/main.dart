import 'package:b2bmobile/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:b2bmobile/firebase_options.dart';
import 'package:b2bmobile/Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/responsive/responsive_layout_screen.dart';
import 'package:b2bmobile/responsive/mobile_screen_layout.dart';
import 'package:b2bmobile/responsive/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase initialization alert: $e");
  }
  if (kDebugMode) {
    try {
      await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
      debugPrint('App Verification Disabled for Testing');
    } catch (e) {
      debugPrint('Could not disable app verification: $e');
    }
  }
  
  debugPrint('FIREBASE INITIALIZED - RUNNING APP');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          lazy: false,
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Back2Black Mobile',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
          appBarTheme: const AppBarTheme(
            // Ensures the back-arrow and all leading/action icons are white
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            foregroundColor: Colors.white, // title + icon colour
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: mobileBackgroundColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
