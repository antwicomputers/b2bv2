import 'package:flutter/material.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions({super.key});

  @override
  State<MoreOptions> createState() => _SettingsState();
}

class _SettingsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is the MoreOptions page'),
    );
  }
}
