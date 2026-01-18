import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              const SizedBox(
                height: 25.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Ready to connect with the vibrant community of black-owned businesses? Back2Black Mobile enables endless possibilities for growth and success. Our app provides you with easy access to a network of proudly owned black businesses, where you can discover new products, services, and opportunities. You'll also have access to exclusive content, resources, and events designed to help you thrive. With the Back2Black Mobile app, you can stay connected with other like-minded entrepreneurs and build lasting relationships that will take your business to new heights.",
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
