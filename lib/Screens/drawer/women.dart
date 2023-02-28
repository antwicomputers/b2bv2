import 'package:flutter/material.dart';

class Women extends StatefulWidget {
  const Women({super.key});

  @override
  State<Women> createState() => _AboutUsState();
}

class _AboutUsState extends State<Women> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Women Empowerment'),
      ),
    );
  }
}
