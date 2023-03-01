import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("About"),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/aboutusHeader.jpeg"),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Back2Black Mobile was created to establish a network of proudly owned black businesses to share their knowledge and experience in how to grow together and keep our dollar in our community"
                  ". It is extremely important for our community to build relationships to last. We must make it a habit to support and praise each other by going the extra mile to grow together and not apart. Coming together to promote our plans for the growth of our community and children will promote healthy business partnerships and allow us to build multi-billion dollar businesses.",
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
