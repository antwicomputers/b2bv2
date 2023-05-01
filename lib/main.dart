import 'package:b2bmobile/Screens/splash%20screen/splash_screen.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
        ),
        home: const SplashScreen(),
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.hasData) {
        //         return const ResponsiveLayout(
        //           mobileScreenLayout: MobileScreenLayout(),
        //           webScreenLayout: WebScreenLayout(),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       }
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(
        //           color: primaryColor,
        //         ),
        //       );
        //     }
        //     return const LoginScreen();
        //   },
        // ),
      ),
    );
  }
}
