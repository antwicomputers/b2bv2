import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditResourceScreen extends StatefulWidget {
  final Support support;
  const EditResourceScreen({super.key, required this.support});

  @override
  State<EditResourceScreen> createState() => _EditResourceScreenState();
}

class _EditResourceScreenState extends State<EditResourceScreen> {
  late TextEditingController _businessName;
  late TextEditingController _businessDescription;
  late TextEditingController _businessAddress;
  late TextEditingController _businessCategory;
  late TextEditingController _phone;
  late TextEditingController _email;
  late TextEditingController _website;
  late TextEditingController _twitter;
  late TextEditingController _facebook;
  late TextEditingController _linkedIn;
  late TextEditingController _instagram;
  late TextEditingController _tiktok;
  late TextEditingController _twitch;
  late TextEditingController _youtube;
  late TextEditingController _podcast;
  
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _businessName = TextEditingController(text: widget.support.supportName);
    _businessDescription = TextEditingController(text: widget.support.supportDescription);
    _businessAddress = TextEditingController(text: widget.support.supportAddress);
    _businessCategory = TextEditingController(text: widget.support.supportCategory);
    _phone = TextEditingController(text: widget.support.phone);
    _email = TextEditingController(text: widget.support.email);
    _website = TextEditingController(text: widget.support.website);
    _twitter = TextEditingController(text: widget.support.twitter);
    _facebook = TextEditingController(text: widget.support.facebook);
    _linkedIn = TextEditingController(text: widget.support.linkedIn);
    _instagram = TextEditingController(text: widget.support.instagram);
    _tiktok = TextEditingController(text: widget.support.tiktok);
    _twitch = TextEditingController(text: widget.support.twitch);
    _youtube = TextEditingController(text: widget.support.youtube);
    _podcast = TextEditingController(text: widget.support.podcast);
  }

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
    _youtube.dispose();
    _podcast.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        _image = im;
      });
    }
  }

  final _formsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Resource'),
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
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _image != null
                                ? Container(
                                    height: 250,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: MemoryImage(_image!),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 250,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(widget.support.supportUrl),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                        Positioned(
                          bottom: 0,
                          left: 200,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _businessName,
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
                  TextFormField(
                    controller: _businessAddress,
                    decoration: const InputDecoration(
                        label: Text('Business Address'),
                        prefixIcon: Icon(Icons.location_city)),
                  ),
                  TextFormField(
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
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        label: Text('email'),
                        prefixIcon: Icon(FontAwesomeIcons.at)),
                  ),
                  TextFormField(
                    controller: _website,
                    decoration: const InputDecoration(
                      label: Text('Website'),
                      prefixIcon: Icon(FontAwesomeIcons.intercom),
                    ),
                  ),
                  TextFormField(
                    controller: _twitter,
                    decoration: const InputDecoration(
                      label: Text('Twitter'),
                      prefixIcon: Icon(FontAwesomeIcons.twitter),
                    ),
                  ),
                  TextFormField(
                    controller: _facebook,
                    decoration: const InputDecoration(
                      label: Text('Facebook'),
                      prefixIcon: Icon(FontAwesomeIcons.facebook),
                    ),
                  ),
                  TextFormField(
                    controller: _youtube,
                    decoration: const InputDecoration(
                      label: Text('Youtube'),
                      prefixIcon: Icon(FontAwesomeIcons.youtube),
                    ),
                  ),
                  TextFormField(
                    controller: _linkedIn,
                    decoration: const InputDecoration(
                      label: Text('LinkedIn'),
                      prefixIcon: Icon(FontAwesomeIcons.linkedin),
                    ),
                  ),
                  TextFormField(
                    controller: _instagram,
                    decoration: const InputDecoration(
                      label: Text('Instagram'),
                      prefixIcon: Icon(FontAwesomeIcons.instagram),
                    ),
                  ),
                  TextFormField(
                    controller: _tiktok,
                    decoration: const InputDecoration(
                      label: Text('Tik Tok'),
                      prefixIcon: Icon(Icons.tiktok),
                    ),
                  ),
                  TextFormField(
                    controller: _twitch,
                    decoration: const InputDecoration(
                      label: Text('Twitch'),
                      prefixIcon: Icon(FontAwesomeIcons.twitch),
                    ),
                  ),
                  TextFormField(
                    controller: _podcast,
                    decoration: const InputDecoration(
                        label: Text('Podcast'),
                        prefixIcon: Icon(FontAwesomeIcons.podcast)),
                  ),
                  const SizedBox(height: 20),
                  Consumer<UserProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String message = await value.updateUserResource(
                          supportId: widget.support.supportId,
                          supportName: _businessName.text,
                          supportDescription: _businessDescription.text,
                          supportAddress: _businessAddress.text,
                          supportCategory: _businessCategory.text,
                          phone: _phone.text,
                          youtube: _youtube.text,
                          email: _email.text,
                          website: _website.text,
                          twitter: _twitter.text,
                          facebook: _facebook.text,
                          linkedIn: _linkedIn.text,
                          instagram: _instagram.text,
                          tiktok: _tiktok.text,
                          twitch: _twitch.text,
                          podcast: _podcast.text,
                          currentSupportUrl: widget.support.supportUrl,
                          businessFile: _image,
                        );
                        setState(() {
                          _isLoading = false;
                        });

                        if (!context.mounted) return;
                        if (message == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resource Updated Successfully')),
                          );
                          Navigator.pop(context);
                        } else {
                          showSnackBar(message, context);
                        }
                      },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Update Resource'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
