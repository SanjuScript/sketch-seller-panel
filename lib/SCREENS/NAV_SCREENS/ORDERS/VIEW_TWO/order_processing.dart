import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/asset_helper.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/WIDGETS/CARDS/order_processor_card.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:drawer_panel/WIDGETS/keep_alive_me.dart';
import 'package:flutter/material.dart';

class OrderProcessingScreen extends StatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  late Future<List<OrderDetailModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = GetOrderDetails.getOrdersUpdatable();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return CustomKeepAliveMe(
      keepAlive: true,
      child: Scaffold(
        body: FutureBuilder<List<OrderDetailModel>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading orders"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No orders found"));
            }

            List<OrderDetailModel> orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var order = orders[index];

                return OrderProcessorCard(
                  orderDetailModel: order,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

