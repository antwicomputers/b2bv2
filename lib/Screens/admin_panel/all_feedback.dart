import 'package:flutter/material.dart';

class AllFeedback extends StatefulWidget {
  const AllFeedback({super.key});

  @override
  State<AllFeedback> createState() => _AllFeedbackState();
}

class _AllFeedbackState extends State<AllFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const InkWell(
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text('Feedback'),
      ),
      body: Scaffold(),
    );
  }
}
