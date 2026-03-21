import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/address_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../pages/verification_screen.dart';
import 'package:b2bmobile/utils/categories.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _cardBg = Color(0xFF141414);
const _inputBg = Color(0xFF1E1E1E);
const _borderColor = Color(0xFF2A2A2A);

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
  final TextEditingController _youtube = TextEditingController();
  final TextEditingController _podcast = TextEditingController();
  
  final List<Uint8List> _images = [];
  bool isBlack = false;
  bool isEssential = false;
  bool isWomen = false;
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
    _youtube.dispose();
    _podcast.dispose();
    super.dispose();
  }

  Future<void> _pickGalleryImage() async {
    if (_images.length >= 3) {
      showSnackBar('Maximum 3 images allowed', context);
      return;
    }
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        _images.add(im);
      });
    }
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
                'Register Business',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
                    child: Icon(Icons.business_center, size: 120, color: _silver),
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
                    const _SectionHeader(icon: Icons.photo_library_outlined, title: 'Business Gallery (Max 3)'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length < 3 ? _images.length + 1 : 3,
                        itemBuilder: (context, index) {
                          if (index == _images.length && _images.length < 3) {
                            return GestureDetector(
                              onTap: _pickGalleryImage,
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: _inputBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: _borderColor, width: 2),
                                ),
                                child: const Icon(Icons.add_a_photo, color: Colors.white24, size: 30),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: MemoryImage(_images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () => setState(() => _images.removeAt(index)),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.info_outline, title: 'Basic Information'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(
                          controller: _businessName,
                          label: 'Business Name',
                          icon: Icons.store,
                          required: true,
                        ),
                        _divider(),
                        _StyledMultilineField(
                          controller: _businessDescription,
                          label: 'Description',
                          icon: Icons.description,
                          required: true,
                        ),
                        _divider(),
                        CategoryDropdown(
                          selectedCategory: _businessCategory.text,
                          onChanged: (val) {
                            if (val != null) setState(() => _businessCategory.text = val);
                          },
                          icon: Icons.category,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.location_on_outlined, title: 'Location'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _AdaptedAutocomplete(
                          controller: _businessAddress,
                          label: 'Business Address',
                          icon: Icons.location_city,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.contact_phone_outlined, title: 'Contact'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(
                          controller: _phone,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        _divider(),
                        _StyledField(
                          controller: _email,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _divider(),
                        _StyledField(
                          controller: _website,
                          label: 'Website',
                          icon: Icons.language,
                          prefix: 'https://www.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.share_outlined, title: 'Social Media'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(controller: _twitter, label: 'Twitter / X', icon: FontAwesomeIcons.twitter, prefix: 'twitter.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _facebook, label: 'Facebook', icon: FontAwesomeIcons.facebook, prefix: 'facebook.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _instagram, label: 'Instagram', icon: FontAwesomeIcons.instagram, prefix: 'instagram.com/', isFa: true),
                        _divider(),
                        _StyledField(controller: _tiktok, label: 'TikTok', icon: Icons.tiktok, prefix: 'tiktok.com/'),
                        _divider(),
                        _StyledField(controller: _linkedIn, label: 'LinkedIn', icon: FontAwesomeIcons.linkedin, prefix: 'linkedin.com/in/', isFa: true),
                        _divider(),
                        _StyledField(controller: _youtube, label: 'YouTube', icon: FontAwesomeIcons.youtube, isFa: true),
                        _divider(),
                        _StyledField(controller: _twitch, label: 'Twitch', icon: FontAwesomeIcons.twitch, prefix: 'twitch.tv/', isFa: true),
                        _divider(),
                        _StyledField(controller: _podcast, label: 'Podcast URL', icon: FontAwesomeIcons.podcast, isFa: true),
                      ],
                    ),

                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        if (_images.isEmpty) {
                          showSnackBar('Please add at least one business photo', context);
                          return;
                        }
                        if (!_formsKey.currentState!.validate()) {
                          showSnackBar('Please fill all required fields', context);
                          return;
                        }
                        
                        // Navigate to Verification Screen instead of uploading directly
                        Get.to(() => VerificationScreen(
                          data: {
                            'businessName': _businessName.text,
                            'businessDescription': _businessDescription.text,
                            'businessAddress': _businessAddress.text,
                            'businessCategory': _businessCategory.text,
                            'phone': _phone.text,
                            'email': _email.text,
                            'website': _website.text,
                            'twitter': _twitter.text,
                            'facebook': _facebook.text,
                            'instagram': _instagram.text,
                            'tiktok': _tiktok.text,
                            'linkedIn': _linkedIn.text,
                            'youtube': _youtube.text,
                            'twitch': _twitch.text,
                            'podcast': _podcast.text,
                          },
                          images: _images,
                          type: 'business',
                        ));
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFFC0C0C0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Review & Confirm',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
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
// Reusable design components
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
        Text(title.toUpperCase(), style: const TextStyle(color: _silver, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _StyledField extends StatelessWidget {
  const _StyledField({required this.controller, required this.label, required this.icon, this.prefix, this.keyboardType = TextInputType.text, this.inputFormatters, this.required = false, this.isFa = false});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? prefix;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool required;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
