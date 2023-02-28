import 'dart:typed_data';

import 'package:b2bmobile/Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({super.key});

  @override
  State<RegisterBusiness> createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  TextEditingController _businessName = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _twitter =
      TextEditingController(text: "https://www.twitter.com/");
  TextEditingController _linkedIn =
      TextEditingController(text: "https://www.linkedin.com/");
  TextEditingController _instagram =
      TextEditingController(text: "https://www.instagram.com/");
  TextEditingController _facebook =
      TextEditingController(text: "https://www.facebook.com/");
  TextEditingController _businessDescription = TextEditingController();
  TextEditingController _podcast = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _businessName.dispose();
    _country.dispose();
    _city.dispose();
    _category.dispose();
    _address.dispose();
    _twitter.dispose();
    _linkedIn.dispose();
    _instagram.dispose();
    _facebook.dispose();
    _businessDescription.dispose();
    _podcast.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
// set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            //text field input for username
            TextFieldInput(
              hintText: 'Enter Business Name',
              textInputType: TextInputType.text,
              textEditingController: _businessName,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Business Description',
              textInputType: TextInputType.text,
              textEditingController: _businessDescription,
            ),
            const SizedBox(
              height: 24,
            ),
            //username text box
            TextFieldInput(
              hintText: 'Enter Business Country',
              textInputType: TextInputType.text,
              textEditingController: _country,
            ),
            const SizedBox(
              height: 24,
            ),
            //text field input for email
            TextFieldInput(
              hintText: 'Enter Business City',
              textInputType: TextInputType.text,
              textEditingController: _city,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Business Category',
              textInputType: TextInputType.text,
              textEditingController: _city,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Business Address',
              textInputType: TextInputType.text,
              textEditingController: _address,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter twitter account handle',
              textInputType: TextInputType.text,
              textEditingController: _twitter,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter LinkedIn account handle',
              textInputType: TextInputType.text,
              textEditingController: _linkedIn,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Instagram account handle',
              textInputType: TextInputType.text,
              textEditingController: _instagram,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Facebook account handle',
              textInputType: TextInputType.text,
              textEditingController: _facebook,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'Enter Podcast',
              textInputType: TextInputType.text,
              textEditingController: _podcast,
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
