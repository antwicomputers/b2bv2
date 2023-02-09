import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({super.key});

  @override
  State<RegisterBusiness> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterBusiness> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _businessNameController.dispose();
    _fullAddressController.dispose();
    _categoryController.dispose();
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
              // svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
              ),
              const SizedBox(height: 64),
              //text field input for username
              TextFieldInput(
                hintText: 'Enter your Business Name',
                textInputType: TextInputType.text,
                textEditingController: _businessNameController,
              ),
              const SizedBox(
                height: 24,
              ),
              //username text box
              TextFieldInput(
                hintText: 'Enter Address',
                textInputType: TextInputType.text,
                textEditingController: _fullAddressController,
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for email
              TextFieldInput(
                hintText: 'Business Category/Type',
                textInputType: TextInputType.emailAddress,
                textEditingController: _categoryController,
              ),
              const SizedBox(
                height: 24,
              ),

              const SizedBox(
                height: 24,
              ),
              //button for login
              Ink(
                child: Container(
                  child: const Text('Login'),
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
              //Transition to sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Already have an account?  "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
