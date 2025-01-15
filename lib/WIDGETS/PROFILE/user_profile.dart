import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drawer_panel/EXTENSIONS/color_ext.dart';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/user_data_fn.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/font_helper.dart';
import 'package:drawer_panel/MODEL/user_model.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return StreamBuilder<UserDataModel?>(
      stream: UserData.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No user data available"));
        } else {
          UserDataModel user = snapshot.data!;
          log(user.profile.toString());

          return Column(
            children: [
              user.profile != null
                  ? CachedNetworkImage(
                      imageUrl: user.profile ?? 'default_image_url',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 40,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const CircleAvatar(radius: 40),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: "FFFAFA".toColor(),
                        radius: 40,
                        child: const Icon(
                          Icons.person_2,
                          size: 28,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: "FFFAFA".toColor(),
                      radius: 40,
                      child: const Icon(
                        Icons.person_2,
                        size: 30,
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                user.fullName ?? 'No Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.email ?? '',
                style: PerfectTypogaphy.regular.copyWith(
                  color: Colors.black87,
                  overflow: TextOverflow.ellipsis,
                  fontSize: size.width * 0.034,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                'Art Lover | Creative Soul',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
