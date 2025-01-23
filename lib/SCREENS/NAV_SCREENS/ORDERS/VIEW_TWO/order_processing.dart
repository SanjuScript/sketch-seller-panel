import 'package:drawer_panel/WIDGETS/CARDS/order_processor_card.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';

class OrderProcessingScreen extends StatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (context, index) {
          return OrderProcessorCard();
        },
      ),
    );
  }
}
