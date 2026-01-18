import 'package:b2bmobile/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:b2bmobile/models/events.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/images.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
  });
  final Events event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isLiked = false;
  int likeCount = 0;
  bool isFavorite = false;
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    // Load the like count and check if the current user liked the business
    loadLikeCountAndCheckLiked();
    loadFavoriteCountandCheckFavorited();
  }

  void loadFavoriteCountandCheckFavorited() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventId)
          .get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          likeCount = data['favoriteCount'] ?? 0;
          isLiked = data['favoriteBy']?[uid] ?? false;
        });
      }
    }
  }

  //toggle favorites
  void toggleFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentReference businessRef = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(businessRef);
        if (snapshot.exists) {
          int currentFavorite =
              (snapshot.data() as Map<String, dynamic>)['favoriteCount'] ?? 0;
          bool isBusinessLiked =
              (snapshot.data() as Map<String, dynamic>)['favoriteBy']?[uid] ??
                  false;

          if (isBusinessLiked) {
            // Unlike the business
            transaction
                .update(businessRef, {'favoriteCount': currentFavorite - 1});
            transaction.update(businessRef, {'favoriteBy.$uid': false});
          } else {
            // Like the business
            transaction
                .update(businessRef, {'favoriteCount': currentFavorite + 1});
            transaction.update(businessRef, {'favoriteBy.$uid': true});
          }
        }
      });

      setState(() {
        favoriteCount = isFavorite ? favoriteCount - 1 : favoriteCount + 1;
        isFavorite = !isFavorite;
      });
    }
  }

  void loadLikeCountAndCheckLiked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventId)
          .get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          likeCount = data['likeCount'] ?? 0;
          isLiked = data['likedBy']?[uid] ?? false;
        });
      }
    }
  }

  void toggleLike() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentReference businessRef = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(businessRef);
        if (snapshot.exists) {
          int currentFavorite =
              (snapshot.data() as Map<String, dynamic>)['likeCount'] ?? 0;
          bool isBusinessLiked =
              (snapshot.data() as Map<String, dynamic>)['likedBy']?[uid] ??
                  false;

          if (isBusinessLiked) {
            // Unlike the business
            transaction.update(businessRef, {'likeCount': currentFavorite - 1});
            transaction.update(businessRef, {'likedBy.$uid': false});
          } else {
            // Like the business
            transaction.update(businessRef, {'likeCount': currentFavorite + 1});
            transaction.update(businessRef, {'likedBy.$uid': true});
          }
        }
      });

      setState(() {
        likeCount = isLiked ? likeCount - 1 : likeCount + 1;
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.event.eventName),
          actions: [
            InkWell(
              onTap: () {},
              child: const Row(
                children: [
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
                        widget.event.eventUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0),
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
                                icon: Icon(
                                  isLiked
                                      ? Icons.thumb_up_alt
                                      : Icons.thumb_up_alt_outlined,
                                  color: isLiked ? Colors.white : null,
                                ),
                                onPressed: toggleLike,
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: isFavorite ? Colors.white : null,
                                ),
                                onPressed: toggleFavorite,
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
                        'Address: ${widget.event.eventAddress}',
                      ),
                    ),
                    const Icon(
                      Icons.category,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.event.eventCategory),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget.event.eventName,
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
                      widget.event.eventDescription,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    widget.event.facebook.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.facebook.com/${widget.event.facebook}'));
                            },
                            icon: const Icon(
                              Icons.facebook,
                              size: 40,
                            ),
                          ),
                    widget.event.email.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri(
                                scheme: 'mailto',
                                path: widget.event.email,
                                queryParameters: {'subject': 'Hi'},
                              ));
                            },
                            icon: const Icon(
                              Icons.mail,
                              size: 40,
                            ),
                          ),
                    widget.event.phone.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(
                                  Uri.parse('tel:${widget.event.phone}'));
                            },
                            icon: const Icon(
                              Icons.phone,
                              size: 40,
                            ),
                          ),
                    widget.event.website.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.${widget.event.website}'));
                            },
                            icon: const Icon(
                              Icons.language,
                              size: 40,
                            ),
                          ),
                    widget.event.twitter.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(
                                  'https://twitter.com/${widget.event.twitter}'));
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
                    widget.event.twitch.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.twitch.tv/${widget.event.twitch}'));
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
                    widget.event.tiktok.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.tiktok.com/${widget.event.tiktok}'));
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
                    widget.event.linkedIn.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.linkedin.com/in/${widget.event.linkedIn}'));
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
                    widget.event.instagram.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(
                                  'https://www.instagram.com/${widget.event.instagram}'));
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
                    widget.event.youtube.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              await _launchUrl(Uri.parse(widget.event.youtube));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.youtube,
                            ),
                          ),
                    widget.event.podcast.isEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              await _launchUrl(Uri.parse(widget.event.podcast));
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
