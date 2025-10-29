import 'package:flutter/material.dart';

class CustomSectionHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool showSearchBox;
  final bool showDrawer;
  final bool showFilterButton;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final String? searchHintText;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onProfilePressed;
  final ImageProvider? profileImage;

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
    required this.showDrawer,
    required this.height,
    this.onProfilePressed,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff01342C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onProfilePressed,
                    child: CircleAvatar(
                      backgroundImage: profileImage,
                      backgroundColor: Colors.grey[200],
                      child:
                          profileImage == null
                              ? Icon(Icons.person, color: Colors.grey[600])
                              : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (showDrawer)
                    Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(
                              Icons.menu_open,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
