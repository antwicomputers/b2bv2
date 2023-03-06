import 'package:flutter/material.dart';

class BlackKickStart extends StatefulWidget {
  const BlackKickStart({super.key});

  @override
  State<BlackKickStart> createState() => _MentalHealthState();
}

class _MentalHealthState extends State<BlackKickStart> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        bottomSheet: InkWell(
          onTap: () {
            print('you clicked the bottom');
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/bks.jpeg"),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "The Black KickStart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Support a Business",
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
