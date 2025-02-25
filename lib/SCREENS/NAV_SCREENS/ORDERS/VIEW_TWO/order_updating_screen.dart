import 'dart:developer';
import 'package:drawer_panel/FUNCTIONS/EDIT_PRODUCT_FN/edit_product.dart';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/admin_data.dart';
import 'package:flutter/material.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_order_fn.dart';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/user_data_fn.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/status_getters.dart';
import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/HELPER/status_model.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/WIDGETS/CARDS/show_user_info_card.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/stepper_widget.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/tracking_list.dart';
import 'package:drawer_panel/WIDGETS/delivery_time_updater.dart';
import 'package:drawer_panel/WIDGETS/helper_text.dart';

class OrderUpdatingScreen extends StatefulWidget {
  final OrderDetailModel orderDetailModel;
  const OrderUpdatingScreen({super.key, required this.orderDetailModel});

  @override
  State<OrderUpdatingScreen> createState() => _OrderUpdatingScreenState();
}

class _OrderUpdatingScreenState extends State<OrderUpdatingScreen> {
  late Future<OrderDetailModel?> _ordersFuture;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  void _fetchOrder() {
    setState(() {
      _ordersFuture =
          GetOrderDetails.getOrderById(widget.orderDetailModel.orderId);
    });
  }

  Future<void> _updateOrderStatus(OrderDetailModel order) async {
    if (_selectedStatus == null || _selectedStatus == order.tracking?.stage) {
      showToast("Current stage and selected stage cannot be the same");
      return;
    }

    final token =
        await UserData.getUserNfToken(order.userID).then((_tok) async {
      await UpdateOrderDetails.updateTrackingStage(
          _tok!, order.orderId, _selectedStatus!);
      log("Updated status: $_selectedStatus");

      _fetchOrder();
      if (_selectedStatus == "Delivered") {
        await EditProduct.incrementProductStats(order.productDetails!.catName,
            order.productDetails!.artTypeId, order.transactionModel!.amount);
        await UpdateAdminData.incrementTotalEarnings(
            order.transactionModel!.amount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.update_rounded, color: Colors.white),
        title: const Text('Update Order Status',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchOrder(),
        child: SingleChildScrollView(
          child: FutureBuilder<OrderDetailModel?>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text("Error loading order"));
              }

              final order = snapshot.data!;
              _selectedStatus ??= order.tracking?.stage ?? "Order Confirmed";

              final statuses = StatusDataGetter.getStatuses(
                  order.tracking?.stage ?? "Order Confirmed");
              final dropStatuses = StatusDataGetter.getStatusesForDropDown();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  ShowUserInfoCard(orderDetailModel: order),
                  StepperWidget(
                      orderDetailModel: order,
                      statuses: statuses,
                      currentStep: _getCurrentStep(order)),
                  _buildEstimatedDelivery(order),
                  UpdateDeliveryTimeWidget(
                    orderDetailModel: order,
                    onUpdateDelivery: (tim) =>
                        UpdateOrderDetails.updateOrderDeliveryTime(
                            orderId: order.orderId, additionalDays: tim),
                  ),
                  OrderTrackingDetailDispalyer(
                      orderId: order.orderId, userId: order.userDetails!.uid!),
                  _buildStatusDropdown(dropStatuses),
                  _buildUpdateButton(order),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: const Text('Manage and update your order statuses with ease.',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }

  Widget _buildEstimatedDelivery(OrderDetailModel order) {
    final estimatedDelivery = order.estimatedDelivery ??
        order.orderTime!.add(const Duration(days: 7));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HelperText1(
        text:
            "Estimated Delivery: ${DateFormatHelper.formatDateWithTime(estimatedDelivery)}",
        fontSize: 14,
      ),
    );
  }

  Widget _buildStatusDropdown(List<StatusModel> dropStatuses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          value: _selectedStatus,
          onChanged: (String? newValue) =>
              setState(() => _selectedStatus = newValue),
          isExpanded: true,
          underline: Container(),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent),
          items: dropStatuses
              .map((status) => DropdownMenuItem(
                    value: status.title,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Icon(status.icon, color: status.color, size: 24),
                        const SizedBox(width: 16),
                        Text(status.title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                      ]),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(OrderDetailModel order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: ElevatedButton(
        onPressed: () => _updateOrderStatus(order),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 5,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.update, color: Colors.white),
            SizedBox(width: 10),
            Text('Update Status', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  int _getCurrentStep(OrderDetailModel order) {
    String currentStage = order.tracking?.stage ?? "Order Confirmed";
    return StatusDataGetter.getStatuses(currentStage)
        .indexWhere((step) => step.title == currentStage);
  }
}
