import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingRegistrationForm extends StatefulWidget {
  const TrainingRegistrationForm({super.key});

  @override
  State<TrainingRegistrationForm> createState() =>
      _TrainingRegistrationFormState();
}

class _TrainingRegistrationFormState extends State<TrainingRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? dropdownValue;
  String? fullName;
  String? emailAddress;
  String? contactPhoneNumber;
  String? multiLineText;

  final CollectionReference registrationsCollection =
      FirebaseFirestore.instance.collection('registrations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Registration'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select an option:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    '',
                    'Sign up for Training',
                    'More Information',
                    'Support The Movement'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    fullName = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your e-mail address';
                    }
                    if (!isValidEmail(value)) {
                      return 'Please enter a valid e-mail address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailAddress = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contact Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    contactPhoneNumber = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Additional Comments',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter additional comments';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    multiLineText = value;
                  },
                ),
                const SizedBox(height: 16),
                if (dropdownValue == 'Sign up for Training') ...[
                  const Text(
                    'XYZ Nonprofit Organization offers free IT training to youth in need. They equip young individuals with essential skills and knowledge in information technology, empowering them to thrive in the digital world. By bridging the digital divide, XYZ Nonprofit creates opportunities and opens doors to promising careers for underserved youth in the community.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
                if (dropdownValue == 'Support The Movement') ...[
                  const Text(
                    'Donating supplies like technology, pens, papers, etc., is vital in supporting non-profits helping the black community. These resources provide educational tools, bridge the digital divide, and empower individuals to learn, create, and express themselves. By contributing, we foster growth, empowerment, and equality for a more inclusive society.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: () {
                    submitForm();
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await registrationsCollection.add({
          'option': dropdownValue,
          'fullName': fullName,
          'emailAddress': emailAddress,
          'contactPhoneNumber': contactPhoneNumber,
          'multiLineText': multiLineText,
        });

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Successful'),
              content: const Text(
                  'Thank you for signing up. We will get back to you shortly.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetFields();
                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
            if (!mounted) return;
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('An error occurred. Please try again later.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void resetFields() {
    setState(() {
      dropdownValue = null;
      fullName = null;
      emailAddress = null;
      contactPhoneNumber = null;
      multiLineText = null;
    });
  }

  bool isValidEmail(String value) {
    // Simple email validation using a regular expression
    final emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$');
    return emailRegex.hasMatch(value);
  }
}
