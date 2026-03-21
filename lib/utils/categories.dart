import 'package:flutter/material.dart';

const List<String> appCategories = [
  'Retail',
  'Food & Beverage',
  'Health & Wellness',
  'Beauty & Personal Care',
  'Technology & IT',
  'Real Estate',
  'Transportation & Logistics',
  'Education',
  'Professional Services',
  'Arts & Entertainment',
  'Event Planning',
  'Construction & Maintenance',
  'Other'
];

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    required this.icon,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.borderColor = const Color(0xFF2A2A2A),
    this.labelStyle = const TextStyle(color: Colors.white38, fontSize: 13),
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 14),
  });

  final String selectedCategory;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory.isEmpty ? null : selectedCategory,
      hint: Text('Select Category *', style: labelStyle),
      items: appCategories
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat, style: textStyle),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Category is required' : null,
      dropdownColor: backgroundColor,
      style: textStyle,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white30),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white30, size: 18),
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: Color(0xFFF5F5F7), width: 0.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}
