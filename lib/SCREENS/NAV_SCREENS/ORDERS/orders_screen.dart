import 'package:drawer_panel/WIDGETS/CARDS/order_pending_card.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return const OrderPendingCard(
            title: "Wood Burning",
            date: "22-34-3434",
            purchaserName: "Mammmoty",
            
          );
        },
      ),
    );
  }
}
