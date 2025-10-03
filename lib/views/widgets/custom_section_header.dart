import 'package:agro/views/widgets/custom_search_box.dart';
import 'package:flutter/material.dart';

class CustomSectionHeader extends StatelessWidget {
  final String title;
  final bool showSearchBox;
  final bool showDialog;
  final bool showFilterButton;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final String? searchHintText;
  final VoidCallback? onFilterPressed;

  const CustomSectionHeader({
    super.key,
    required this.title,
    this.showSearchBox = false,
    this.showFilterButton = false,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHintText,
    this.onFilterPressed,
    required this.showDialog,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showSearchBox)
              CustomSearchBox(
                controller: searchController,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                hintText: searchHintText,
              ),
            if (showFilterButton)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: onFilterPressed,
              ),
          ],
        ),
      ],
    );
  }
}
