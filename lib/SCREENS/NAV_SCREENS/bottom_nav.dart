import 'package:drawer_panel/PROVIDER/NAV/bottom_nav_provider.dart';
import 'package:drawer_panel/PROVIDER/NAV/order_pending_provider.dart';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/order_tabs.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/transaction_screen.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:drawer_panel/WIDGETS/bottom_nav_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/home_screen.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/profile_screen.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
      checkNotificationPermission(context);
      NotificationService.init();
    final navProvider = Provider.of<BottomNavProvider>(context);
    final screens = [
      HomeScreen(),
      const TransactionScreen(),
      const OrderTabs(),
      const ProfileScreen()
    ];

    return PopScope(
      canPop: navProvider.canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !navProvider.canPop) {
          navProvider.updateIndex(0);
        }
      },
      child: Scaffold(
        body: screens[navProvider.currentIndex],
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                  text: "Home",
                  icon: Icons.home,
                  selected: navProvider.currentIndex == 0,
                  onPressed: () => navProvider.updateIndex(0),
                ),
                IconBottomBar(
                  text: "Transactions",
                  icon: Icons.receipt_long_outlined,
                  selected: navProvider.currentIndex == 1,
                  onPressed: () => navProvider.updateIndex(1),
                ),
                Consumer<PendingCountProvider>(builder: (context, count, _) {
                  return IconBottomBar(
                    text: "Orders",
                    icon: Icons.local_grocery_store_outlined,
                    showDot: count.shouldShowDot,
                    selected: navProvider.currentIndex == 2,
                    onPressed: () => navProvider.updateIndex(2),
                  );
                }),
                IconBottomBar(
                  text: "Profile",
                  icon: Icons.person_outline,
                  selected: navProvider.currentIndex == 3,
                  onPressed: () => navProvider.updateIndex(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
