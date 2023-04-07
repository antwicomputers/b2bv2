import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoNew.jpg',
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Back2blackmobile: Growing Together')
          ],
        ),
      ),
    );
  }
}
