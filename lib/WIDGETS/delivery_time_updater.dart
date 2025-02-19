import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateDeliveryTimeWidget extends StatefulWidget {
  final OrderDetailModel orderDetailModel;
  final Function(int days) onUpdateDelivery;

  const UpdateDeliveryTimeWidget({
    super.key,
    required this.orderDetailModel,
    required this.onUpdateDelivery,
  });

  @override
  _UpdateDeliveryTimeWidgetState createState() =>
      _UpdateDeliveryTimeWidgetState();
}

class _UpdateDeliveryTimeWidgetState extends State<UpdateDeliveryTimeWidget> {
  int selectedDays = 1;

  @override
  Widget build(BuildContext context) {
    DateTime newEstimatedDate =
        widget.orderDetailModel.orderTime!.add(Duration(days: selectedDays));

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Adjust Delivery Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<int>(
            dropdownColor: Colors.white,
            value: selectedDays,
            decoration: InputDecoration(
              labelText: "Select Extra Days",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: List.generate(10, (index) => index + 1)
                .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(
                        "$day day${day > 1 ? 's' : ''}",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(fontSize: 17),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedDays = value);
              }
            },
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.deepPurple, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text(
                  "New Estimated Delivery: ${DateFormat('dd MMM yyyy').format(newEstimatedDate)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple.shade900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                widget.onUpdateDelivery(selectedDays);
              },
              icon: const Icon(Icons.update),
              label: const Text("Update Delivery Time"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
