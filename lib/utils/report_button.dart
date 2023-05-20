import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DropDownTextFieldScreen extends StatefulWidget {
  @override
  _DropDownTextFieldScreenState createState() =>
      _DropDownTextFieldScreenState();
}

class _DropDownTextFieldScreenState extends State<DropDownTextFieldScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedOption;
  TextEditingController textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  void saveData() async {
    String userInput = textFieldController.text;
    Timestamp timestamp = Timestamp.now(); // Get current timestamp
    await _firestore.collection('userfeedback').add({
      'option': selectedOption,
      'userInput': userInput,
      'timestamp': timestamp, // Include timestamp in the data
    });
    textFieldController.clear();
    setState(() {
      selectedOption = null;
    });
    // Show a success message or perform any other desired actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Feedback'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              items: <String?>[
                null,
                'Not Black Owned',
                'Bad Interaction',
                'Other'
              ].map<DropdownMenuItem<String>>(
                (String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value ?? 'Select an option'),
                  );
                },
              ).toList(),
              decoration: InputDecoration(
                labelText: 'Select Option',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: textFieldController,
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Enter your feedback',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveData,
              child: Text('Save'),
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
                  '\nThe black community must work together for social progress and to overcome systemic challenges. By uniting, black individuals can amplify their voices, address shared issues, and promote positive change. Collaboration allows for a stronger community, fostering understanding and growth for all involved. Our goal is to grow together by understanding negative interactions, working with you and the business owner to make improvements. This is how our community truly thrives!\n'),
            ),
          ],
        ),
      ),
    );
  }
}
