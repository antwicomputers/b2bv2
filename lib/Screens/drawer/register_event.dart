import 'package:flutter/material.dart';

class RegisterEvent extends StatefulWidget {
  const RegisterEvent({super.key});

  @override
  State<RegisterEvent> createState() => _AboutUsState();
}

class _AboutUsState extends State<RegisterEvent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Register Event'),
    );
  }
}
