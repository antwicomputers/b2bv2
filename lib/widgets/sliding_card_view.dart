import 'package:flutter/material.dart';

class SlidingCardView extends StatefulWidget {
  const SlidingCardView({super.key});

  @override
  State<SlidingCardView> createState() => _SlidingCardViewState();
}

class _SlidingCardViewState extends State<SlidingCardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
