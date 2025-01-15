import 'package:drawer_panel/API/permission_api.dart';
import 'package:drawer_panel/MODEL/user_model.dart';
import 'package:drawer_panel/PROVIDER/profile_editing_provider.dart';
import 'package:drawer_panel/WIDGETS/PROFILE/profile_pic.dart';
import 'package:drawer_panel/WIDGETS/PROFILE/user_info_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDataModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.user.fullName!;
    final provider = Provider.of<ProfileProvider>(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          provider.clearFields();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    final status =
                        await PermissionApi.requestStorageOrPhotosPermission(
                            context);
                    if (status) {
                      profileProvider.pickImage(context);
                    }
                  },
                  child: Hero(
                    tag: widget.user.profile!,
                    child: Material(
                      surfaceTintColor: Colors.transparent,
                      color: Colors.transparent,
                      child: ProfilePic(
                        image: widget.user.profile!,
                        imageUploadBtnPress: () {},
                        img: profileProvider.croppedFile,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Form(
                  child: Column(
                    children: [
                      UserInfoEditField(
                        text: "Name",
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                const Color(0xFF00BF6D).withOpacity(0.05),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                        ),
                      ),
                      UserInfoEditField(
                          text: "Email", child: Text(widget.user.email!)),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      String newName = nameController.text;
                      profileProvider.setName(newName);
                      await profileProvider.saveProfile(context);
                    },
                    child: const Text("Save Update"),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
