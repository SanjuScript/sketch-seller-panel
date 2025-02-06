import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_order_fn.dart';
import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/ORDER/tracking_details.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/global_dialogue.dart';
import 'package:flutter/material.dart';

class OrderTrackingDetailDispalyer extends StatelessWidget {
  final String orderId;
  final String userId;

  const OrderTrackingDetailDispalyer(
      {super.key, required this.orderId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrackingModel?>(
      future: GetOrderDetails.getTrackingModelByOrderId(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        if (snapshot.hasData) {
          final trackingModel = snapshot.data!;

          List<MapEntry<String, DateTime>> sortedUpdatedStages = trackingModel
              .updatedStages.entries
              .map((e) => MapEntry(e.key, DateTime.parse(e.value.toString())))
              .toList()
            ..sort((a, b) => a.value.compareTo(b.value));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Updated Stages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                sortedUpdatedStages.isEmpty
                    ? const Text('No previous stages')
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sortedUpdatedStages.length,
                        itemBuilder: (context, index) {
                          String stage = sortedUpdatedStages[index].key;
                          return ListTile(
                            title: Text(stage),
                            subtitle: Text(
                                "Timestamp: ${DateFormatHelper.formatDateTime(sortedUpdatedStages[index].value) ?? "N/A"}"),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmationDialog(
                                  context: context,
                                  title: "Delete Stage",
                                  message:
                                      "Are you sure you want to delete this stage? This action cannot be undone.",
                                  confirmText: "Delete",
                                  onConfirm: () {
                                    UpdateOrderDetails.deleteUpdatedStage(
                                        userId, orderId, stage);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        }

        return const Center(child: Text('No data available.'));
      },
    );
  }
}
