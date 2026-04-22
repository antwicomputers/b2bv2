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

class SearchableCategoryField extends StatefulWidget {
  const SearchableCategoryField({
    super.key,
    required this.controller,
    required this.icon,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.borderColor = const Color(0xFF2A2A2A),
    this.labelStyle = const TextStyle(color: Colors.white38, fontSize: 13),
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 14),
  });

  final TextEditingController controller;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  @override
  State<SearchableCategoryField> createState() => _SearchableCategoryFieldState();
}

class _SearchableCategoryFieldState extends State<SearchableCategoryField> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          final String query = textEditingValue.text;
          if (query.isEmpty) {
            return appCategories;
          }
          
          final matches = appCategories.where((String option) {
            return option.toLowerCase().contains(query.toLowerCase());
          }).toList();

          // If the query doesn't exactly match any existing category, 
          // add the custom typed value as an option at the top or bottom
          final bool exactlyMatches = appCategories.any(
            (element) => element.toLowerCase() == query.toLowerCase()
          );

          if (!exactlyMatches && query.isNotEmpty) {
            // We can return the custom query as an option
            return [query, ...matches];
          }

          return matches;
        },
        onSelected: (String selection) {
          widget.controller.text = selection;
        },
        fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
          // Initialize textController with external controller's value
          if (textController.text.isEmpty && widget.controller.text.isNotEmpty) {
            textController.text = widget.controller.text;
          }

          // Simple sync
          textController.addListener(() {
            if (widget.controller.text != textController.text) {
              widget.controller.text = textController.text;
            }
          });

          return TextFormField(
            controller: textController,
            focusNode: focusNode,
            style: widget.textStyle,
            validator: (v) => (v == null || v.isEmpty) ? 'Category is required' : null,
            decoration: InputDecoration(
              labelText: 'Business Category *',
              labelStyle: widget.labelStyle,
              hintText: 'Search or type new category...',
              hintStyle: widget.labelStyle.copyWith(fontSize: 12),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(widget.icon, color: Colors.white30, size: 18),
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
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: constraints.maxWidth,
                margin: const EdgeInsets.only(top: 4), // Small gap from field
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  border: Border.all(color: widget.borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: widget.borderColor),
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    final bool isNew = !appCategories.contains(option);
                    
                    return ListTile(
                      leading: Icon(
                        isNew ? Icons.add_circle_outline : Icons.check_circle_outline,
                        color: isNew ? Colors.blueAccent : Colors.white24,
                        size: 16,
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(option, style: widget.textStyle)),
                          if (isNew)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
