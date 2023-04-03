import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WomenBusiness extends StatefulWidget {
  const WomenBusiness({super.key});

  @override
  _WomenBusinessState createState() => _WomenBusinessState();
}

class _WomenBusinessState extends State<WomenBusiness> {
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
              "Click to Explore Women Owned Businesses",
              style: TextStyle(
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
              Image.asset("assets/womenHeader.jpeg"),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "One For Our Black Queens",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Black Queens. You are strong, fierce and resilient. You are determined and dedicate yourselves to everything you do.  You are a force to be reckoned with and we want you to know that we see you, admire you, love you, support you and thank you. We are giving you your own section in Back2Black Mobile to make it easy for others who want to support you and your businesses. We salute you!",
                  textAlign: TextAlign.justify,
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
