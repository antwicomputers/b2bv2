import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/predict_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditBusinessScreen extends StatefulWidget {
  final Business business;
  const EditBusinessScreen({super.key, required this.business});

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
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
  bool isBlack = false;
  bool isEssential = false;
  bool isWomen = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _businessName = TextEditingController(text: widget.business.businessName);
    _businessDescription = TextEditingController(text: widget.business.businessDescription);
    _businessAddress = TextEditingController(text: widget.business.businessAddress);
    _businessCategory = TextEditingController(text: widget.business.businessCategory);
    _phone = TextEditingController(text: widget.business.phone);
    _email = TextEditingController(text: widget.business.email);
    _website = TextEditingController(text: widget.business.website);
    _twitter = TextEditingController(text: widget.business.twitter);
    _facebook = TextEditingController(text: widget.business.facebook);
    _linkedIn = TextEditingController(text: widget.business.linkedIn);
    _instagram = TextEditingController(text: widget.business.instagram);
    _tiktok = TextEditingController(text: widget.business.tiktok);
    _twitch = TextEditingController(text: widget.business.twitch);
    _youtube = TextEditingController(text: widget.business.youtube);
    _podcast = TextEditingController(text: widget.business.podcast);

    isBlack = widget.business.isBlackOwned;
    isEssential = widget.business.isEsential;
    isWomen = widget.business.womenOriented;
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
        title: const Text('Edit Business'),
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
                                      image: NetworkImage(widget.business.businessUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        ),
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
                  SwitchListTile(
                    title: const Text('Black Owned Business?'),
                    value: isBlack,
                    onChanged: (bool value) {
                      setState(() {
                        isBlack = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Essential Service? (Mental Health, etc)'),
                    value: isEssential,
                    onChanged: (bool value) {
                      setState(() {
                        isEssential = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Women Owned?'),
                    value: isWomen,
                    onChanged: (bool value) {
                      setState(() {
                        isWomen = value;
                      });
                    },
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
                  // Social Media Fields
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _website,
                    decoration: const InputDecoration(
                      label: Text('Website'),
                      prefixIcon: Icon(FontAwesomeIcons.intercom),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _twitter,
                    decoration: const InputDecoration(
                      label: Text('Twitter'),
                      prefixIcon: Icon(FontAwesomeIcons.twitter),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _facebook,
                    decoration: const InputDecoration(
                      label: Text('Facebook'),
                      prefixIcon: Icon(FontAwesomeIcons.facebook),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _youtube,
                    decoration: const InputDecoration(
                      label: Text('Youtube'),
                      prefixIcon: Icon(FontAwesomeIcons.youtube),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _linkedIn,
                    decoration: const InputDecoration(
                      label: Text('LinkedIn'),
                      prefixIcon: Icon(FontAwesomeIcons.linkedin),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _instagram,
                    decoration: const InputDecoration(
                      label: Text('Instagram'),
                      prefixIcon: Icon(FontAwesomeIcons.instagram),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _tiktok,
                    decoration: const InputDecoration(
                      label: Text('Tik Tok'),
                      prefixIcon: Icon(Icons.tiktok),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _twitch,
                    decoration: const InputDecoration(
                      label: Text('Twitch'),
                      prefixIcon: Icon(FontAwesomeIcons.twitch),
                    ),
                  ),
                   TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _podcast,
                    decoration: const InputDecoration(
                        label: Text('Podcast'),
                        prefixIcon: Icon(FontAwesomeIcons.podcast)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddressScreen()));
                    },
                    child: const Text('Change Address'),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String message = await value.updateBusiness(
                          businessId: widget.business.businessId,
                          businessName: _businessName.text,
                          businessDescription: _businessDescription.text,
                          businessAddress: _businessAddress.text,
                          businessCategory: _businessCategory.text,
                          phone: _phone.text,
                          isBlackOwned: isBlack,
                          isEsential: isEssential,
                          womenOriented: isWomen,
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
                          currentBusinessUrl: widget.business.businessUrl,
                          businessFile: _image,
                        );
                        setState(() {
                          _isLoading = false;
                        });

                        if (message == 'success') {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Business Updated Successfully')),
                          );
                          Navigator.pop(context); // Return to MyBusinesses
                        } else {
                           if (!context.mounted) return;
                           showSnackBar(message, context);
                        }
                      },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Update Business'),
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
