import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MentalHealth extends StatefulWidget {
  const MentalHealth({super.key});

  @override
  State<MentalHealth> createState() => _MentalHealthState();
}

class _MentalHealthState extends State<MentalHealth> {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        bottomSheet: InkWell(
          onTap: () {
            if (kDebugMode) {
              print('you clicked the bottom');
            }
          },
          child: Container(
            height: 50,
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: const Center(
                child: Text(
              "Click to Explore Essential Services",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            )),
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
              Image.asset("assets/health.jpeg"),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Mental Health",
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
                  "mental health is a critical issue for African Americans, and the impact of mental health disorders on our population is significant. To address these issues, B2B will dedicate a section of the app to connect our kings and queens with the best ressources avaialble to assist with mental health issues. Together, we will help save our community!",
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
