import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade200,
              Colors.green.shade400,
              Colors.green.shade600,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green.shade800),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AgroVigya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Farming Companion',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            // Drawer Items
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.of(context).pushReplacementNamed('/home'),
            ),
            _buildDrawerItem(
              icon: Icons.eco,
              text: 'Crop Recommendation',
              onTap:
                  () => Navigator.of(context).pushNamed('/crop_recommendation'),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Labor Estimation',
              onTap: () => Navigator.of(context).pushNamed('/labor_estimation'),
            ),
            const Divider(color: Colors.white54),
            _buildDrawerItem(
              icon: Icons.store,
              text: 'Marketplace',
              onTap: () => Navigator.of(context).pushNamed('/marketplace'),
            ),
            _buildDrawerItem(
              icon: Icons.policy,
              text: 'Govt. Schemes',
              onTap: () => Navigator.of(context).pushNamed('/govt_schemes'),
            ),
            _buildDrawerItem(
              icon: Icons.work,
              text: 'Job Search',
              onTap: () => Navigator.of(context).pushNamed('/job_search'),
            ),
            const Divider(color: Colors.white54),
            _buildDrawerItem(
              icon: Icons.info,
              text: 'About Us',
              onTap: () => Navigator.of(context).pushNamed('/about'),
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
