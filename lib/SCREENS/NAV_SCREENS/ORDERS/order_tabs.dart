import 'package:flutter/material.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_ONE/orders_screen.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_TWO/order_processing.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * .15),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            leading: const Icon(Icons.delivery_dining_sharp),
            title: const Text(
              "Order Management",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            centerTitle: false,
            elevation: 5,
            shadowColor: Colors.black26,
            bottom: const TabBar(
              dividerColor: Colors.transparent,
              indicatorPadding: EdgeInsets.all(10),
              labelPadding: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              indicatorWeight: .5,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white70,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt_rounded),
                  text: "Orders",
                ),
                Tab(
                  icon: Icon(Icons.edit_rounded),
                  text: "Edit Status",
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F9FA), Color(0xFFE8ECEF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const TabBarView(
            children: [
              OrdersScreen(),
              OrderProcessingScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
