import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupportUs extends StatefulWidget {
  const SupportUs({super.key});

  @override
  State<SupportUs> createState() => _SupportUsState();
}

class _SupportUsState extends State<SupportUs> {
  final TextEditingController _feedback = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _feedback.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _feedback,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Enter Your Feedback",
            filled: true,
          ),
          maxLines: 10,
          maxLength: 4096,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'Cannot be empty';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
          ),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String message;

              try {
                final collection = FirebaseFirestore.instance.collection('feedback');

                await collection.doc().set(
                  {
                    'timestamp': FieldValue.serverTimestamp(),
                    'feedback': _feedback.text,
                  },
                );
              } catch (_) {
                message = 'error when sending feedback';
              }
            }
          },
          child: const Text(
            'Send',
          ),
        ),
      ],
    );
  }
}
