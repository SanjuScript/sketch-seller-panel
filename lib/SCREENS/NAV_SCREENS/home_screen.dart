import 'dart:developer';
import 'package:drawer_panel/FUNCTIONS/UPLOAD_FN/product_upload_fn.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/asset_helper.dart';
import 'package:drawer_panel/MODEL/catagory_art_model.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/blood_art_screen.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/blue_art.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/glass_art.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/pencil_art.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/resin_art.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/wood_burning.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/creater_button.dart';
import 'package:drawer_panel/WIDGETS/CARDS/art_type_card.dart';
import 'package:drawer_panel/WIDGETS/premuim_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<ArtCategory> artCategories = [
    ArtCategory(title: 'Wood Burning', imagePath: GetAsset.wb1),
    ArtCategory(title: 'Blood Art', imagePath: GetAsset.wb2),
    ArtCategory(title: 'Resin Art', imagePath: GetAsset.wb3),
    ArtCategory(title: 'Blue Art', imagePath: GetAsset.wb6),
    ArtCategory(title: 'Glass Art', imagePath: GetAsset.gl1),
    ArtCategory(title: 'Sketch', imagePath: GetAsset.dr1),
  ];
  final screens = [
    const WoodBurningScreen(),
    const BloodArtScreen(),
    const ResinArtScreen(),
    const BlueArtScreen(),
    const GlassArtScreen(),
    const PencilArtScreen()
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: const PremiumDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.deepPurple),
          onPressed: () async {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Welcome, Admin!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Manage your products by selecting a category below.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 5),
            const CreaterButton(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: artCategories.length,
                itemBuilder: (context, index) {
                  final art = artCategories[index];
                  return ArtCategoryCard(
                    title: art.title,
                    imagePath: art.imagePath,
                    onTap: () {
                      log("Tapped on ${art.title}");

                      if (index >= 0 && index < screens.length) {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) => CategoryScreen(categoryName: art.title,)),
                        // );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => screens[index]),
                        );
                      } else {
                        log("No matching screen for ${art.title}");
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
