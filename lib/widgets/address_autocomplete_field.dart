import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/config_service.dart';

/// Drop-in replacement for an address TextFormField.
/// Shows Google Places autocomplete suggestions as an overlay
/// below the field while the user types.
///
/// Usage:
///   AddressAutocompleteField(
///     controller: _addressController,
///     label: 'Business Address',
///   )
///
/// The [controller] receives the full chosen address string automatically.
class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({
    super.key,
    required this.controller,
    this.label = 'Address',
    this.prefixIcon = Icons.location_city,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  static const _endpoint =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  List<String> _predictions = [];
  bool _showDropdown = false;
  bool _suppressNext = false; // prevents re-fetching after user taps a result

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_suppressNext) {
      _suppressNext = false;
      return;
    }
    final text = widget.controller.text.trim();
    if (text.length < 3) {
      if (mounted) setState(() => _showDropdown = false);
      return;
    }
    _fetchPredictions(text);
  }

  Future<void> _fetchPredictions(String input) async {
    try {
      final apiKey = await ConfigService().getSecretKey('google_maps_key');
      if (apiKey.isEmpty) return;

      final url = Uri.parse(
          '$_endpoint?input=${Uri.encodeComponent(input)}&key=$apiKey');
      final resp = await http.get(url);
      if (resp.statusCode == 200 && mounted) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        final list = (data['predictions'] as List<dynamic>? ?? [])
            .map((p) => p['description'] as String)
            .toList();
        setState(() {
          _predictions = list;
          _showDropdown = list.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Places API error: $e');
    }
  }

  void _selectAddress(String address) {
    _suppressNext = true;
    widget.controller.text = address;
    // Move cursor to end
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: address.length),
    );
    setState(() => _showDropdown = false);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            label: Text(widget.label),
            prefixIcon: Icon(widget.prefixIcon),
            suffixIcon: _showDropdown
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() => _showDropdown = false);
                    },
                  )
                : null,
          ),
          validator: widget.validator,
        ),
        if (_showDropdown)
          Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _predictions.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16),
                itemBuilder: (ctx, i) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_pin,
                        size: 18, color: Colors.redAccent),
                    title: Text(
                      _predictions[i],
                      style: const TextStyle(fontSize: 13),
                    ),
                    onTap: () => _selectAddress(_predictions[i]),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
