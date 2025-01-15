import 'package:drawer_panel/WIDGETS/CARDS/order_pending_card.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        leading: const Icon(
          Icons.pending_actions_rounded,
          color: Colors.black87,
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
       
          return OrderPendingCard();
        },
      ),
    );
  }
}
