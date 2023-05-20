import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SupportUs extends StatefulWidget {
  @override
  _SupportUsState createState() => _SupportUsState();
}

class _SupportUsState extends State<SupportUs> {
  final TextEditingController _feedbackController = TextEditingController();

  // Initialize Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save feedback to Firestore
  Future<void> saveFeedback(String feedback) async {
    try {
      await _firestore.collection('feedback').add({
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Feedback Submitted'),
            content: Text('Thank you for providing feedback.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _feedbackController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit feedback.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('Error adding feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback & Suggestions'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Feedback',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String feedback = _feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  saveFeedback(feedback);
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(
              height: 50,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Back2Black Mobile Facts',
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                '\nSubmitting feedback for a business promotes growth by providing valuable insights, driving improvements, and attracting new customers. It fosters a culture of continuous improvement and demonstrates a commitment to customer satisfaction, enabling businesses to adapt, grow, and thrive.\n',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
