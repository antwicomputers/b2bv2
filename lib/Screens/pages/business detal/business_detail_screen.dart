import 'package:b2bmobile/utils/app_constants.dart';
import 'package:b2bmobile/utils/images.dart';
import 'package:b2bmobile/utils/report_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:b2bmobile/models/business.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({
    Key? key,
    required this.business,
  }) : super(key: key);

  final Business business;

  @override
  _BusinessDetailScreenState createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    // Load the like count from Firebase when the screen is initialized
    loadLikeCount();
  }

  void loadLikeCount() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .doc(widget.business.businessId)
        .get();
    setState(() {
      likeCount = (snapshot.data() as Map<String, dynamic>)['likeCount'] ?? 0;
    });
  }

  void incrementLikeCount() async {
    await FirebaseFirestore.instance
        .collection('businesses')
        .doc(widget.business.businessId)
        .update({'likeCount': likeCount + 1});
    setState(() {
      likeCount = likeCount + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.business.businessName),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DropDownTextFieldScreen(),
                ),
              );
            },
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
                      widget.business.businessUrl,
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
                              onPressed: incrementLikeCount,
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
                      'Address: ${widget.business.businessAddress}',
                    ),
                  ),
                  const Icon(
                    Icons.category,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(widget.business.businessCategory),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.business.businessName,
                style: AppConstants.titleStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
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
                    widget.business.businessDescription,
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
                  widget.business.facebook.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.facebook.com/${widget.business.facebook}'));
                          },
                          icon: const Icon(
                            Icons.facebook,
                            size: 40,
                          ),
                        ),
                  widget.business.email.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri(
                              scheme: 'mailto',
                              path: widget.business.email,
                              queryParameters: {'subject': 'Hi'},
                            ));
                          },
                          icon: const Icon(
                            Icons.mail,
                            size: 40,
                          ),
                        ),
                  widget.business.phone.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(
                                Uri.parse('tel:${widget.business.phone}'));
                          },
                          icon: const Icon(
                            Icons.phone,
                            size: 40,
                          ),
                        ),
                  widget.business.website.isEmpty
                      ? Container()
                      : IconButton(
                          onPressed: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.${widget.business.website}'));
                          },
                          icon: const Icon(
                            Icons.language,
                            size: 40,
                          ),
                        ),
                  widget.business.twitter.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://twitter.com/${widget.business.twitter}'));
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
                  widget.business.twitch.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.twitch.tv/${widget.business.twitch}'));
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
                  widget.business.youtube.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.youtube.com/channel/${widget.business.youtube}'));
                          },
                          child: Padding(
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
                  widget.business.linkedIn.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.linkedin.com/company/${widget.business.linkedIn}'));
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
                  widget.business.instagram.isEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            await _launchUrl(Uri.parse(
                                'https://www.instagram.com/${widget.business.instagram}'));
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
}
