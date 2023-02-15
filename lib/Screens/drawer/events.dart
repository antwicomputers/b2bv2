import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _AboutUsState();
}

class _AboutUsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Events'),
    );
  }
}
