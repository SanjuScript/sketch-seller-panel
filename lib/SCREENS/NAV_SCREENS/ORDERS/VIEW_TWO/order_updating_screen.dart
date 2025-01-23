import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

class OrderUpdatingScreen extends StatefulWidget {
  const OrderUpdatingScreen({super.key});

  @override
  State<OrderUpdatingScreen> createState() => _OrderUpdatingScreenState();
}

class _OrderUpdatingScreenState extends State<OrderUpdatingScreen> {
  final List<Map<String, String>> _statuses = [
    {
      'title': 'Order Confirmed',
      'subtitle': 'The order has been confirmed by the customer.',
    },
    {
      'title': 'Drawing Started',
      'subtitle': 'The Artist has started working on the drawing.',
    },
    {
      'title': 'Drawing Completed',
      'subtitle': 'The drawing has been completed and is under packing.',
    },
    {
      'title': 'Shipped',
      'subtitle': 'The product has been shipped to the courier service.',
    },
    {
      'title': 'Out for Delivery',
      'subtitle': 'The product is out for delivery to the customer.',
    },
    {
      'title': 'Delivered',
      'subtitle':
          'The product has been delivered to the customer successfully.',
    },
  ];

  final List<IconData> _statusIcons = [
    CupertinoIcons.check_mark_circled,
    CupertinoIcons.paintbrush,
    CupertinoIcons.check_mark,
    Icons.local_shipping,
    Icons.directions_car,
    Icons.check_circle,
  ];

  String? _selectedStatus;
  @override
  Widget build(BuildContext context) {
    int _currentStep = 5;
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
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnotherStepper(
                stepperList: _statuses.asMap().entries.map((entry) {
                  final stepIndex = entry.key;
                  final status = entry.value;

                  return StepperData(
                    title: StepperText(
                      status['title']!,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: stepIndex == _currentStep
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: StepperText(
                      status['subtitle']!,
                      textStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    iconWidget: CircleAvatar(
                      backgroundColor: stepIndex < _currentStep
                          ? Colors.deepPurple
                          : (stepIndex == _currentStep
                              ? (stepIndex == _statuses.length - 1
                                  ? Colors.green
                                  : Colors.deepPurple)
                              : Colors.grey),
                      child: Icon(
                        _statusIcons[stepIndex],
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                activeIndex: _currentStep,
                stepperDirection: Axis.vertical,
                verticalGap: 30,
                barThickness: 5,
                activeBarColor: Colors.deepPurple,
                inActiveBarColor: Colors.grey,
                iconHeight: 40,
                iconWidth: 40,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Status',
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.track_changes,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                dropdownColor: Colors.white,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                iconSize: 28,
                value: _selectedStatus,
                items: _statuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status['title'],
                    child: Text(
                      status['title']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
//FILTER FINISHED LIST ITEM
//