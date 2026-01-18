import 'package:b2bmobile/Screens/pages/kick_start_landing.dart';
import 'package:flutter/material.dart';

class BlackKickStart extends StatefulWidget {
  const BlackKickStart({super.key});

  @override
  State<BlackKickStart> createState() => _MentalHealthState();
}

class _MentalHealthState extends State<BlackKickStart> {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        bottomSheet: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const KickStartLanding()),
            );
          },
          child: Container(
            height: 50,
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                "Start Here",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/bks.jpeg"),
              const SizedBox(
                height: 1,
              ),
              const Text(
                "The Black KickStart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Support Growth and Success:\n\nIntroducing our latest initiative, The Black Kickstart program - an exclusive program designed to provide black-owned businesses with the boost they need to succeed. Our program is meticulously crafted to cater to the specific requirements of black-owned businesses, offering a comprehensive range of services provided by our community that can help accelerate growth, streamline operations and pave the way for success. Are you a resource willing to support the growth of black-owned businesses by providing mentorship, donations, or any other service? Fill out our form to support this movement today!\n\nKickstart Your Business: Search Our Database Today!\n\nAre you looking for mentorship or a service opportunity but lack the financial means to get started? Search our database today for a comprehensive list of resources that can help kickstart your business!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
