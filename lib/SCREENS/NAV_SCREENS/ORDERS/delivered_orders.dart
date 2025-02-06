import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/WIDGETS/CARDS/order_processor_card.dart';
import 'package:flutter/material.dart';

class DeliveredOrders extends StatefulWidget {
  const DeliveredOrders({super.key});

  @override
  State<DeliveredOrders> createState() => _DeliveredOrdersState();
}

class _DeliveredOrdersState extends State<DeliveredOrders> {
  late Future<List<OrderDetailModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = GetOrderDetails.getDeliveredOrders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text("Delivered Orders"),
        leading: const Icon(Icons.delivery_dining_outlined),
      ),
      body:  FutureBuilder<List<OrderDetailModel>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading delivered orders"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No orders delivered"));
            }

            List<OrderDetailModel> orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var order = orders[index];

                return OrderProcessorCard(
                  orderDetailModel: order,
                  forDelivery: true,
                );
              },
            );
          },
        ),
    );
  }
}
