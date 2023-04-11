import 'package:b2bmobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:b2bmobile/models/events.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/images.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(event.eventName),
          actions: [
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Text('Report'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.report_gmailerrorred,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Center(
                child: Container(
                  height: size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        event.eventUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                    ),
                    Expanded(
                      child: Text(
                        'Address: ${event.eventAddress}',
                      ),
                    ),
                    const Icon(
                      Icons.category,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(event.eventCategory),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  event.eventName,
                  style: AppConstants.titleStyle.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      event.eventDescription,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: size.height * 0.1,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    event.facebook.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse('https://www.facebook.com/${event.facebook}'));
                            },
                            icon: const Icon(
                              Icons.facebook,
                              size: 40,
                            ),
                          ),
                    event.email.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri(
                                scheme: 'mailto',
                                path: event.email,
                                queryParameters: {'subject': 'Hi'},
                              ));
                            },
                            icon: const Icon(
                              Icons.mail,
                              size: 40,
                            ),
                          ),
                    event.phone.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse('tel:${event.phone}'));
                            },
                            icon: const Icon(
                              Icons.phone,
                              size: 40,
                            ),
                          ),
                    event.website.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse('https://www.${event.website}'));
                            },
                            icon: const Icon(
                              Icons.language,
                              size: 40,
                            ),
                          ),
                    event.twitter.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse('https://twitter.com/${event.twitter}'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.twitter,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    event.twitch.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse('https://www.twitch.tv/${event.twitch}'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.twitch,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    event.tiktok.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse('https://www.tiktok.com/${event.tiktok}'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.tiktok,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    event.linkedIn.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse('https://www.linkedin.com/in/${event.linkedIn}'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.linkedin,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    event.instagram.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse('https://www.instagram.com/${event.instagram}'));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.instagram,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    event.youtube.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse(event.youtube));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.youtube,
                            ),
                          ),
                    event.podcast.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(event.podcast));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ImageIcon(
                                AssetImage(
                                  Images.podcast,
                                ),
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
