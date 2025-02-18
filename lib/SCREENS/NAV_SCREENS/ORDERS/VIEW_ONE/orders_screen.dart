import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_TWO/order_processing.dart';
import 'package:drawer_panel/WIDGETS/CARDS/order_pending_card.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/no_order_widget.dart';
import 'package:drawer_panel/WIDGETS/keep_alive_me.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<OrderDetailModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    setFuture();
  }

  Future<void> setFuture() async {
    _ordersFuture = GetOrderDetails.getOrdersConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return CustomKeepAliveMe(
      keepAlive: true,
      child: Scaffold(
        body: FutureBuilder<List<OrderDetailModel>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading state
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading orders"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return NoOrdersFound(
                onRefresh: setFuture,
              );
            }

            List<OrderDetailModel> orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var order = orders[index];

                return OrderPendingCard(
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
