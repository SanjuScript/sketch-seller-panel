import 'dart:developer';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_order_fn.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/status_getters.dart';
import 'package:drawer_panel/MODEL/HELPER/status_model.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/stepper_widget.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/tracking_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderUpdatingScreen extends StatefulWidget {
  final OrderDetailModel orderDetailModel;
  const OrderUpdatingScreen({super.key, required this.orderDetailModel});

  @override
  State<OrderUpdatingScreen> createState() => _OrderUpdatingScreenState();
}

class _OrderUpdatingScreenState extends State<OrderUpdatingScreen> {
  int _getCurrentStep() {
    String currentStage =
        widget.orderDetailModel.tracking?.stage ?? "Order Confirmed";

    return StatusDataGetter.getStatuses(currentStage)
        .indexWhere((step) => step.title == currentStage);
  }

  String? _selectedStatus;
  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus =
        widget.orderDetailModel.tracking?.stage ?? "Order Confirmed";
  }

  @override
  Widget build(BuildContext context) {
    String currentStage =
        widget.orderDetailModel.tracking?.stage ?? "Order Confirmed";
    int _currentStep = _getCurrentStep();
    List<StatusModel> statuses = StatusDataGetter.getStatuses(currentStage);
    List<StatusModel> dropStatuses = StatusDataGetter.getStatusesForDropDown();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.update_rounded,
          color: Colors.white,
        ),
        title: Text(
          'Update Order Status',
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  'Manage and update your order statuses with ease.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              StepperWidget(
                  orderDetailModel: widget.orderDetailModel,
                  statuses: statuses,
                  currentStep: _currentStep),
              OrderTrackingDetailDispalyer(
                orderId: widget.orderDetailModel.orderId,
                userId: widget.orderDetailModel.userDetails!.uid!,
              ),
              SizedBox(height: 10),
              Padding(
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
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: _selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                    isExpanded: true,
                    hint: const Text(
                      'Select Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blueAccent,
                    ),
                    iconSize: 28,
                    elevation: 8,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    underline: Container(),
                    items: dropStatuses
                        .map<DropdownMenuItem<String>>((StatusModel status) {
                      return DropdownMenuItem<String>(
                        value: status.title,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                status.icon,
                                color: status.color,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                status.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedStatus != null) {
                      if (widget.orderDetailModel.tracking!.stage !=
                          _selectedStatus) {
                        UpdateOrderDetails.updateTrackingStage(
                            widget.orderDetailModel.userDetails!,
                            widget.orderDetailModel.orderId,
                            _selectedStatus!);
                        log("Selected status: $_selectedStatus");
                        Future.delayed(Durations.medium3, () {
                          refreshData();
                        });
                      } else {
                        showToast(
                            "Current stage and selected stage cannot be same");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.update, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Update Status',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
