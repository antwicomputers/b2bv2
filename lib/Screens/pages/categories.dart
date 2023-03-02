import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _SettingsState();
}

class _SettingsState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is the categories page'),
    );
  }
}
