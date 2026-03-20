import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  final Events event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _eventName;
  late TextEditingController _eventDescription;
  late TextEditingController _eventAddress;
  late TextEditingController _eventCategory;
  late TextEditingController _phone;
  late TextEditingController _email;
  late TextEditingController _website;
  late TextEditingController _twitter;
  late TextEditingController _facebook;
  late TextEditingController _linkedIn;
  late TextEditingController _instagram;
  late TextEditingController _youtube;
  late TextEditingController _tiktok;
  late TextEditingController _twitch;
  late TextEditingController _podcast;

  Uint8List? _image;
  bool _isLoading = false;
  late bool isOnline;
  late DateTime eventDate;

  @override
  void initState() {
    super.initState();
    _eventName = TextEditingController(text: widget.event.eventName);
    _eventDescription = TextEditingController(text: widget.event.eventDescription);
    _eventAddress = TextEditingController(text: widget.event.eventAddress);
    _eventCategory = TextEditingController(text: widget.event.eventCategory);
    _phone = TextEditingController(text: widget.event.phone);
    _email = TextEditingController(text: widget.event.email);
    _website = TextEditingController(text: widget.event.website);
    _twitter = TextEditingController(text: widget.event.twitter);
    _facebook = TextEditingController(text: widget.event.facebook);
    _linkedIn = TextEditingController(text: widget.event.linkedIn);
    _instagram = TextEditingController(text: widget.event.instagram);
    _youtube = TextEditingController(text: widget.event.youtube);
    _tiktok = TextEditingController(text: widget.event.tiktok);
    _twitch = TextEditingController(text: widget.event.twitch);
    _podcast = TextEditingController(text: widget.event.podcast);
    
    isOnline = widget.event.isOnlineEvent;
    eventDate = widget.event.eventDate;
  }

  @override
  void dispose() {
    _eventName.dispose();
    _eventDescription.dispose();
    _eventAddress.dispose();
    _eventCategory.dispose();
    _phone.dispose();
    _youtube.dispose();
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
        title: const Text('Edit Event'),
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
                                      image: NetworkImage(widget.event.eventUrl),
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
                  TextFormField(
                    controller: _eventName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Enter Event Name'),
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _eventDescription,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      label: Text('Enter Event Description'),
                      prefixIcon: Icon(Icons.info),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'event description is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _eventAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'event Address is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Event Address'),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _eventCategory,
                    decoration: const InputDecoration(
                      label: Text('event Category'),
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'category is required';
                      }
                      return null;
                    },
                  ),
                  SwitchListTile(
                    value: isOnline,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    onChanged: (val) {
                      setState(() {
                        isOnline = val;
                      });
                    },
                    title: Row(
                      children: [
                        Icon(Icons.ondemand_video_outlined,
                            color: Theme.of(context).hintColor.withOpacity(0.7)),
                        const SizedBox(width: 10),
                        Text(
                          'Online event',
                          style: TextStyle(
                              color: Theme.of(context).hintColor.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).hintColor,
                    thickness: 1,
                    height: 8,
                  ),
                  ListTile(
                    onTap: () async {
                      DateTime? selectedDate =
                          await picker.DatePicker.showDateTimePicker(
                        context,
                        theme: const picker.DatePickerTheme(
                          backgroundColor: Colors.black,
                          itemStyle: TextStyle(color: Colors.white),
                        ),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          eventDate = selectedDate;
                        });
                      }
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    leading: Icon(Icons.calendar_month,
                        color: Theme.of(context).hintColor.withOpacity(0.7)),
                    horizontalTitleGap: -5,
                    title: Text(
                      'Event Date',
                      style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.7)),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MMM/yyyy hh:mm a').format(eventDate),
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).hintColor,
                    thickness: 1,
                    height: 8,
                  ),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      label: Text('Phone Number'),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: const InputDecoration(
                      label: Text('email'),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
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
                  Consumer<UserProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String message = await value.updateEvent(
                          eventId: widget.event.eventId,
                          eventName: _eventName.text,
                          eventDescription: _eventDescription.text,
                          eventAddress: _eventAddress.text,
                          eventCategory: _eventCategory.text,
                          phone: _phone.text,
                          email: _email.text,
                          eventDate: eventDate,
                          isOnline: isOnline,
                          website: _website.text,
                          twitter: _twitter.text,
                          youtube: _youtube.text,
                          facebook: _facebook.text,
                          linkedIn: _linkedIn.text,
                          instagram: _instagram.text,
                          tiktok: _tiktok.text,
                          twitch: _twitch.text,
                          podcast: _podcast.text,
                          currentEventUrl: widget.event.eventUrl,
                          eventFile: _image,
                        );
                        setState(() {
                          _isLoading = false;
                        });

                        if (message == 'success') {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Event Updated Successfully')),
                          );
                          Navigator.pop(context);
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
                          : const Text('Update Event'),
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
