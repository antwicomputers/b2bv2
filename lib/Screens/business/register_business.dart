import 'package:b2bmobile/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({super.key});

  @override
  State<RegisterBusiness> createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  TextEditingController businessName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController twitter =
      TextEditingController(text: "https://www.twitter.com/");
  TextEditingController linkedIn =
      TextEditingController(text: "https://www.linkedin.com/");
  TextEditingController instagram =
      TextEditingController(text: "https://www.instagram.com/");
  TextEditingController facebook =
      TextEditingController(text: "https://www.facebook.com/");
  TextEditingController businessDescription = TextEditingController();
  TextEditingController podcast = TextEditingController();

  final AuthMethods _auth = AuthMethods();
  bool isWomenOriented = false;
  bool isEssential = false;

  @override
  void dispose() {
    super.dispose();
    businessName.dispose();
    country.dispose();
    city.dispose();
    category.dispose();
    address.dispose();
    twitter.dispose();
    linkedIn.dispose();
    instagram.dispose();
    facebook.dispose();
    businessDescription.dispose();
    podcast.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
