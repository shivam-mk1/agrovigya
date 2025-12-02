import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTap;
  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.08,
      decoration: BoxDecoration(color: Color(0xff01342C)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              widget.onItemTap(0);
            },
            icon: Icon(
              widget.selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              size: widget.selectedIndex == 0 ? 30 : 28,
              color: widget.selectedIndex == 0 ? Colors.white : Colors.white38,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onItemTap(1);
            },
            icon: Icon(
              widget.selectedIndex == 1
                  ? Icons.work_rounded
                  : Icons.work_outline_outlined,
              size: widget.selectedIndex == 1 ? 30 : 28,
              color: widget.selectedIndex == 1 ? Colors.white : Colors.white38,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onItemTap(2);
            },
            icon: Icon(
              widget.selectedIndex == 2 ? Icons.policy : Icons.policy_outlined,
              size: widget.selectedIndex == 2 ? 30 : 28,
              color: widget.selectedIndex == 2 ? Colors.white : Colors.white38,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onItemTap(3);
            },
            icon: Icon(
              widget.selectedIndex == 3
                  ? Icons.store
                  : Icons.store_mall_directory_outlined,
              size: widget.selectedIndex == 3 ? 30 : 28,
              color: widget.selectedIndex == 3 ? Colors.white : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
