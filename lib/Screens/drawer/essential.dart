import 'package:flutter/material.dart';

class Essential extends StatefulWidget {
  const Essential({super.key});

  @override
  State<Essential> createState() => _AboutUsState();
}

class _AboutUsState extends State<Essential> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Essential'),
    );
  }
}
