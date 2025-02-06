import 'dart:developer';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/user_data_fn.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/date_format.dart';
import 'package:drawer_panel/SCREENS/EDITING_SCREENS/profile_editing.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/delivered_orders.dart';
import 'package:drawer_panel/WIDGETS/CARDS/info_cards.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'package:drawer_panel/MODEL/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        leading: const Icon(Icons.person_2_rounded),
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<UserDataModel?>(
          stream: UserData.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              log('Error: ${snapshot.error}', name: "snapshot error");
              return const Center(child: Text('Error loading user data'));
            }

            final user = snapshot.data;

            if (user == null) {
              return const Center(child: Text('No user data found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: user)));
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Hero(
                          tag: user.profile!,
                          child: CircleAvatar(
                            radius: 60,
                            child: CustomCachedImageDisplayer(
                              borderRadius: BorderRadius.circular(100),
                              // height: size.height * .12,
                              // width: size.width * .35,
                              imageUrl: user.profile ??
                                  'https://via.placeholder.com/150',
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: -5,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.fullName ?? 'John Doe',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? 'johndoe@gmail.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoCard(
                          title: 'Joined on',
                          value: DateFormater.formatDate(user.createdAt!),
                          icon: Icons.date_range,
                        ),
                        const SizedBox(height: 10),
                        InfoCard(
                          title: 'Orders Completed',
                          value: (user.totalOders != null)
                              ? user.totalOders.toString()
                              : '0',
                          icon: Icons.shopping_cart_outlined,
                        ),
                        const SizedBox(height: 10),
                        InfoCard(
                          title: 'Orders Pending',
                          value: (user.pending != null)
                              ? user.pending.toString()
                              : '0',
                          icon: Icons.shopping_cart_outlined,
                        ),
                        const SizedBox(height: 10),
                        InfoCard(
                          title: 'Total Earnings',
                          value: (user.earning != null)
                              ? user.earning.toString()
                              : '0',
                          icon: Icons.attach_money_outlined,
                        ),
                        const SizedBox(height: 10),
                        InfoCard(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveredOrders()));
                          },
                          title: 'Delivered Orders',
                          value: (user.earning != null)
                              ? user.earning.toString()
                              : '0',
                          icon: Icons.delivery_dining_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
