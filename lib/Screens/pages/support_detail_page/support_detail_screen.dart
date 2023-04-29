import 'package:b2bmobile/utils/app_constants.dart';
import 'package:b2bmobile/utils/images.dart';
import 'package:flutter/material.dart';

import 'package:b2bmobile/models/support.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportDetailScreen extends StatelessWidget {
  const SupportDetailScreen({
    Key? key,
    required this.support,
  }) : super(key: key);
  final Support support;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(support.supportName),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      support.SupportUrl,
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
                      'Address: ${support.supportAddress}',
                    ),
                  ),
                  const Icon(
                    Icons.category,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(support.supportCategory),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                support.supportName,
                style: AppConstants.titleStyle
                    .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
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
                    support.supportDescription,
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
                  support.facebook.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.facebook.com/${support.facebook}'));
                          },
                          icon: const Icon(
                            Icons.facebook,
                            size: 40,
                          ),
                        ),
                  support.email.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri(
                              scheme: 'mailto',
                              path: support.email,
                              queryParameters: {'subject': 'Hi'},
                            ));
                          },
                          icon: const Icon(
                            Icons.mail,
                            size: 40,
                          ),
                        ),
                  support.phone.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri.parse('tel:${support.phone}'));
                          },
                          icon: const Icon(
                            Icons.phone,
                            size: 40,
                          ),
                        ),
                  support.website.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(
                                Uri.parse('https://www.${support.website}'));
                          },
                          icon: const Icon(
                            Icons.language,
                            size: 40,
                          ),
                        ),
                  support.twitter.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://twitter.com/${support.twitter}'));
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
                  support.twitch.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.twitch.tv/${support.twitch}'));
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
                  support.youtube.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri.parse(support.youtube));
                          },
                          icon: const Icon(
                            FontAwesomeIcons.youtube,
                          ),
                        ),
                  support.tiktok.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.tiktok.com/${support.tiktok}'));
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
                  support.linkedIn.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.linkedin.com/in/${support.linkedIn}'));
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
                  support.instagram.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.instagram.com/${support.instagram}'));
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
                  support.podcast.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(support.podcast));
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
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
