import 'package:b2bmobile/providers/user_provider.dart';
// import 'package:b2bmobile/utils/colors.dart'; // removed unused import
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/address_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:b2bmobile/utils/categories.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
// const _silverDark = Color(0xFF8E8E93); // removed unused element
const _cardBg = Color(0xFF141414);
const _inputBg = Color(0xFF1E1E1E);
const _borderColor = Color(0xFF2A2A2A);

class RegisterEvent extends StatefulWidget {
  const RegisterEvent({super.key});

  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _eventDescription = TextEditingController();
  final TextEditingController _eventAddress = TextEditingController();
  final TextEditingController _eventCategory = TextEditingController();
  final TextEditingController _eventWebsite = TextEditingController();
  final TextEditingController _twitter = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _linkedIn = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _tiktok = TextEditingController();
  final TextEditingController _twitch = TextEditingController();
  final TextEditingController _youtube = TextEditingController();
  final TextEditingController _podcast = TextEditingController();
  
  DateTime? _selectedDate;
  Uint8List? _image;
  bool isOnline = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _eventName.dispose();
    _eventDescription.dispose();
    _eventAddress.dispose();
    _eventCategory.dispose();
    _eventWebsite.dispose();
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
    if (im != null) setState(() => _image = im);
  }

  final _formsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Register Event',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2C2C2E), Color(0xFF000000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Opacity(
                    opacity: 0.12,
                    child: Icon(Icons.calendar_today, size: 120, color: _silver),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Form(
              key: _formsKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: selectImage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: _inputBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: _image != null ? _silver : _borderColor, width: 2.5),
                            boxShadow: _image != null
                                ? [BoxShadow(color: _silver.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)]
                                : [],
                            image: _image != null ? DecorationImage(image: MemoryImage(_image!), fit: BoxFit.cover) : null,
                          ),
                          child: _image == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, color: _silver, size: 36),
                                    SizedBox(height: 6),
                                    Text('Event Poster', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (_image != null)
                      Center(
                        child: TextButton.icon(
                          onPressed: selectImage,
                          icon: const Icon(Icons.edit, size: 14, color: _silver),
                          label: const Text('Change Poster', style: TextStyle(color: _silver, fontSize: 12)),
                        ),
                      ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.event_note, title: 'Event Details'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(controller: _eventName, label: 'Event Name', icon: Icons.title, required: true),
                        _divider(),
                        _StyledMultilineField(controller: _eventDescription, label: 'Description', icon: Icons.description, required: true),
                        _divider(),
                        CategoryDropdown(
                          selectedCategory: _eventCategory.text,
                          onChanged: (val) {
                            if (val != null) setState(() => _eventCategory.text = val);
                          },
                          icon: Icons.category,
                        ),
                        _divider(),
                        _DatePickerTile(
                          selectedDate: _selectedDate,
                          onTap: () {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              onConfirm: (date) => setState(() => _selectedDate = date),
                              currentTime: _selectedDate ?? DateTime.now(),
                              locale: picker.LocaleType.en,
                              theme: const picker.DatePickerTheme(
                                backgroundColor: _cardBg,
                                itemStyle: TextStyle(color: Colors.white, fontSize: 18),
                                doneStyle: TextStyle(color: _silver, fontSize: 16, fontWeight: FontWeight.bold),
                                cancelStyle: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            );
                          },
                        ),
                        _divider(),
                        _StyledSwitch(title: 'Online Event?', value: isOnline, onChanged: (val) => setState(() => isOnline = val)),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.location_on_outlined, title: 'Location'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _AdaptedAutocomplete(controller: _eventAddress, label: 'Event Address', icon: Icons.location_city),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.link, title: 'Links & Social'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(controller: _eventWebsite, label: 'Event Website', icon: Icons.language, prefix: 'https://'),
                        _divider(),
                        _StyledField(controller: _twitter, label: 'Twitter', icon: FontAwesomeIcons.twitter, prefix: 'twitter.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _facebook, label: 'Facebook', icon: FontAwesomeIcons.facebook, prefix: 'facebook.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _instagram, label: 'Instagram', icon: FontAwesomeIcons.instagram, prefix: 'instagram.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _youtube, label: 'YouTube', icon: FontAwesomeIcons.youtube, isFa: true),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Consumer<UserProvider>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (_image == null) {
                                  showSnackBar('Please add an event poster', context);
                                  return;
                                }
                                if (_selectedDate == null) {
                                  showSnackBar('Please select an event date', context);
                                  return;
                                }
                                if (!_formsKey.currentState!.validate()) return;
                                
                                setState(() => _isLoading = true);
                                String message = await value.registerEvent(
                                  eventName: _eventName.text,
                                  eventDescription: _eventDescription.text,
                                  eventAddress: _eventAddress.text,
                                  eventCategory: _eventCategory.text,
                                  phone: '', // Optional or add field if needed
                                  email: '', // Optional or add field if needed
                                  website: _eventWebsite.text,
                                  twitter: _twitter.text,
                                  facebook: _facebook.text,
                                  linkedIn: _linkedIn.text,
                                  instagram: _instagram.text,
                                  tiktok: _tiktok.text,
                                  eventDate: _selectedDate!,
                                  twitch: _twitch.text,
                                  youtube: _youtube.text,
                                  isOnline: isOnline,
                                  podcast: _podcast.text,
                                  eventFile: _image!,
                                );
                                setState(() => _isLoading = false);
                                
                                if (message == 'success') {
                                  if (!context.mounted) return;
                                  Get.offAll(() => const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(), webScreenLayout: WebScreenLayout()));
                                } else {
                                  if (!context.mounted) return;
                                  showSnackBar(message, context);
                                }
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _isLoading
                                ? const LinearGradient(colors: [Color(0xFF555555), Color(0xFF333333)])
                                : const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFC0C0C0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _isLoading ? [] : [BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6))],
                          ),
                          child: Center(
                            child: _isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black)) : const Text('Register Event', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable components
// ─────────────────────────────────────────────────────────────────────────────

Widget _divider() => const Divider(height: 1, thickness: 1, color: _borderColor, indent: 16, endIndent: 16);

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: _silver.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: _silver, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title.toUpperCase(), style: const TextStyle(color: _silver, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _StyledField extends StatelessWidget {
  const _StyledField({required this.controller, required this.label, required this.icon, this.prefix, this.required = false, this.isFa = false});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? prefix;
  // final TextInputType keyboardType; // removed unused parameter
  // final List<TextInputFormatter>? inputFormatters; // removed unused parameter
  final bool required;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
//      keyboardType: keyboardType, // removed unused parameter
//      inputFormatters: inputFormatters, // removed unused parameter
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: required ? (v) => (v == null || v.isEmpty) ? '$label is required' : null : null,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Padding(padding: const EdgeInsets.all(12), child: isFa ? FaIcon(icon, color: Colors.white30, size: 16) : Icon(icon, color: Colors.white30, size: 18)),
        prefix: prefix != null ? Text(prefix!, style: const TextStyle(color: Colors.white30, fontSize: 13)) : null,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: const BorderSide(color: _silver, width: 0.5)),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}

class _StyledMultilineField extends StatelessWidget {
  const _StyledMultilineField({required this.controller, required this.label, required this.icon, this.required = false});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      minLines: 2,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: required ? (v) => (v == null || v.isEmpty) ? '$label is required' : null : null,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        alignLabelWithHint: true,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Padding(padding: const EdgeInsets.only(left: 12, top: 14, right: 0), child: Icon(icon, color: Colors.white30, size: 18)),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: const BorderSide(color: _silver, width: 0.5)),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}

class _StyledSwitch extends StatelessWidget {
  const _StyledSwitch({required this.title, required this.value, required this.onChanged});
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: _silver,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.selectedDate, required this.onTap});
  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.calendar_month, color: Colors.white30, size: 18)),
      title: Text(selectedDate == null ? 'Select Event Date & Time' : DateFormat('MMM d, yyyy - h:mm a').format(selectedDate!), style: TextStyle(color: selectedDate == null ? Colors.white38 : Colors.white, fontSize: 13)),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.white30),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

class _AdaptedAutocomplete extends StatelessWidget {
  const _AdaptedAutocomplete({required this.controller, required this.label, required this.icon});
  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(inputDecorationTheme: const InputDecorationTheme(labelStyle: TextStyle(color: Colors.white38, fontSize: 13), border: InputBorder.none, filled: true, fillColor: Colors.transparent)),
      child: AddressAutocompleteField(controller: controller, label: label, prefixIcon: icon),
    );
  }
}
