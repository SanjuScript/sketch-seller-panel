import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/image_problem.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ImageIssueButton extends StatelessWidget {
  final Function(String) onIssueSelected;
  final String orderID;

  const ImageIssueButton({
    super.key,
    required this.orderID,
    required this.onIssueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: GetOrderDetails.hasOrderIssue(orderID),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return !snapshot.data!
                ? TextButton.icon(
                    onPressed: () {
                      showImageIssueDialog(context, (msg) {
                        log(msg);
                        onIssueSelected(msg);
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.red.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 22),
                    label: const Text(
                      "Issue with Image?",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_rounded,
                            color: Colors.deepPurple, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Issue updated successfully. The user has not corrected or uploaded a new image.",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple.shade900,
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return const SizedBox();
        });
  }
}
