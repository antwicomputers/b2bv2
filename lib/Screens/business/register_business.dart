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
  State<RegisterBusiness> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterBusiness> {
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

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              // SvgPicture.asset(
              //   'assets/ic_b2b1.svg',
              //   color: primaryColor,
              // ),
              // const SizedBox(height: 64),
              //circular widget to accpt and show our selected file
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
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

              //button for login
              InkWell(
                onTap: () {},
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Container(
                        child: const Text('Register Business'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor,
                        ),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
