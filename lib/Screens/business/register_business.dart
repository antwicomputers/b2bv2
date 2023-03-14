import 'package:b2bmobile/resources/auth_methods.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import 'package:image_picker/image_picker.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({super.key});

  @override
  State<RegisterBusiness> createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();
  final TextEditingController _businessAddress = TextEditingController();
  final TextEditingController _businessCategory = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _website = TextEditingController();
  final TextEditingController _twitter = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _linkedIn = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _tiktok = TextEditingController();
  final TextEditingController _twitch = TextEditingController();
  final TextEditingController _podcast = TextEditingController();
  Uint8List? _image;
  final bool isBlack = false;
  final bool isEssential = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _businessName.dispose();
    _businessDescription.dispose();
    _businessAddress.dispose();
    _businessCategory.dispose();
    _phone.dispose();
    _email.dispose();
    _website.dispose();
    _twitter.dispose();
    _facebook.dispose();
    _linkedIn.dispose();
    _instagram.dispose();
    _tiktok.dispose();
    _twitch.dispose();
    _podcast.dispose();

    super.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  final _formsKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.arrow_back,
        ),
        title: const Text('Register Business'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formsKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    //color: Colors.white,
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _image != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _image == null
                                          ? Container(
                                              height: 150,
                                              width: 50,
                                              child:
                                                  const CircularProgressIndicator(),
                                            )
                                          : Container(
                                              height: 250,
                                              width: 250,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  image: MemoryImage(_image!),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ))
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add_a_photo,
                                          ),
                                          iconSize: 50,
                                          onPressed: selectImage,
                                        ),
                                      ),
                                    )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: _businessName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        label: Text('Enter Business Name'),
                        prefixIcon: Icon(Icons.monetization_on)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'business name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _businessDescription,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        label: Text('Enter Business Description'),
                        prefixIcon: Icon(Icons.info)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'business description is required';
                      }
                      return null;
                    },
                  ),
                  // TextFormField(
                  //   keyboardType: TextInputType.text,
                  //   decoration: const InputDecoration(
                  //       label: Text('Business Country'),
                  //       prefixIcon: Icon(Icons.location_city)),
                  // ),
                  // TextFormField(
                  //   keyboardType: TextInputType.text,
                  //   decoration: const InputDecoration(
                  //     label: Text('Business City'),
                  //     prefixIcon: Icon(Icons.location_city),
                  //   ),
                  // ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _businessAddress,
                    decoration: const InputDecoration(
                        label: Text('Business Address'),
                        prefixIcon: Icon(Icons.location_city)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _businessCategory,
                    decoration: const InputDecoration(
                        label: Text('Business Category'),
                        prefixIcon: Icon(Icons.category)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'category is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        label: Text('Phone Number'),
                        prefixIcon: Icon(Icons.phone)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: const InputDecoration(
                        label: Text('email'),
                        prefixIcon: Icon(FontAwesomeIcons.at)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _website,
                    decoration: const InputDecoration(
                        label: Text('Website'),
                        prefixIcon: Icon(FontAwesomeIcons.intercom)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _twitter,
                    decoration: const InputDecoration(
                        label: Text('Twitter'),
                        prefixIcon: Icon(FontAwesomeIcons.twitter)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _facebook,
                    decoration: const InputDecoration(
                        label: Text('Facebook'),
                        prefixIcon: Icon(FontAwesomeIcons.facebook)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _linkedIn,
                    decoration: const InputDecoration(
                        label: Text('LinkedIn'),
                        prefixIcon: Icon(FontAwesomeIcons.linkedin)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _instagram,
                    decoration: const InputDecoration(
                        label: Text('Instagram'),
                        prefixIcon: Icon(FontAwesomeIcons.instagram)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _tiktok,
                    decoration: const InputDecoration(
                        label: Text('Tik Tok'), prefixIcon: Icon(Icons.tiktok)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _twitch,
                    decoration: const InputDecoration(
                        label: Text('Twitch'),
                        prefixIcon: Icon(FontAwesomeIcons.twitch)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _podcast,
                    decoration: const InputDecoration(
                        label: Text('Podcast'),
                        prefixIcon: Icon(FontAwesomeIcons.podcast)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //   onPressed: selectImages,
                  //   child: const Text('Select 3 Images'),
                  // ),

                  ElevatedButton(
                    onPressed: registerBusiness,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Register Business'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerBusiness() async {
    setState(() {
      _isLoading = true;
    });
    String message = await AuthMethods().registerBusiness(
      businessName: _businessName.text,
      businessDescription: _businessDescription.text,
      businessAddress: _businessAddress.text,
      businessCategory: _businessCategory.text,
      phone: _phone.text,
      email: _email.text,
      website: _website.text,
      twitter: _twitter.text,
      facebook: _facebook.text,
      linkedIn: _linkedIn.text,
      instagram: _instagram.text,
      tiktok: _tiktok.text,
      twitch: _twitch.text,
      podcast: _podcast.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (message == 'success') {
      showSnackBar(message, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }
}
