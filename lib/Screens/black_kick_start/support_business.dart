import 'package:b2bmobile/providers/user_provider.dart';
// import 'package:b2bmobile/utils/colors.dart'; // removed unused import
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/address_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/utils/categories.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
// const _silverDark = Color(0xFF8E8E93); // removed unused element
const _cardBg = Color(0xFF141414);
const _inputBg = Color(0xFF1E1E1E);
const _borderColor = Color(0xFF2A2A2A);

class SupportBusiness extends StatefulWidget {
  const SupportBusiness({super.key});

  @override
  State<SupportBusiness> createState() => _SupportBusinessState();
}

class _SupportBusinessState extends State<SupportBusiness> {
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
  Uint8List? _image;
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
              title: const Text('Black Kickstart Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                    child: Icon(Icons.rocket_launch, size: 100, color: _silver),
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
                                    Text('Add Photo', style: TextStyle(color: Colors.white54, fontSize: 12)),
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
                          label: const Text('Change Photo', style: TextStyle(color: _silver, fontSize: 12)),
                        ),
                      ),

                    const SizedBox(height: 28),
                    const _SectionHeader(icon: Icons.info_outline, title: 'Submission Info'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(controller: _businessName, label: 'Business/Resource Name', icon: Icons.monetization_on, required: true),
                        _divider(),
                        _StyledMultilineField(controller: _businessDescription, label: 'Detailed Description', icon: Icons.description, required: true),
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
                        _AdaptedAutocomplete(controller: _businessAddress, label: 'Address (if applicable)', icon: Icons.location_city),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(icon: Icons.contact_phone_outlined, title: 'Contact / Link'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _StyledField(controller: _phone, label: 'Phone Number', icon: Icons.phone, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                        _divider(),
                        _StyledField(controller: _email, label: 'Email Address', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        _divider(),
                        _StyledField(controller: _website, label: 'Website', icon: Icons.language, prefix: 'https://www.'),
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

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: _silver.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: _silver.withValues(alpha: 0.2))),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: _silver, size: 18),
                          SizedBox(width: 10),
                          Expanded(child: Text('Submitted businesses for Kickstart will be pinned globally upon approval.', style: TextStyle(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    Consumer<UserProvider>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (_image == null) {
                                  showSnackBar('Please add a business/resource photo', context);
                                  return;
                                }
                                if (!_formsKey.currentState!.validate()) return;
                                
                                setState(() => _isLoading = true);
                                String message = await value.registerSupport(
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
                                  businessFile: _image!,
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
                            child: _isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black)) : const Text('Submit for Review', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
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
