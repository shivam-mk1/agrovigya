import 'package:agro/providers/navprovider.dart';
import 'package:agro/utils/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: navigationProvider.currentScreen,
      bottomNavigationBar: NavBar(
        selectedIndex: navigationProvider.selectedIndex,
        onItemTap: (index) {
          navigationProvider.setIndex(index);
        },
      ),
    );
  }
}