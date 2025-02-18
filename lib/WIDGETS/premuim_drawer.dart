import 'package:drawer_panel/WIDGETS/DIALOGS/logout_dia.dart';
import 'package:drawer_panel/WIDGETS/PROFILE/user_profile.dart';
import 'package:flutter/material.dart';

class PremiumDrawer extends StatelessWidget {
  const PremiumDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Container(
        color: Colors.deepPurpleAccent,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: UserProfile(),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () async {
                showLogoutDialogue(context: context);
              },
            ),
            const Divider(color: Colors.white, thickness: 0.5),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Art Studio - Version 1.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
