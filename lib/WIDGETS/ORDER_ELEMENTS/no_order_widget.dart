import 'package:drawer_panel/HELPERS/CONSTANTS/asset_helper.dart';
import 'package:flutter/material.dart';

class NoOrdersFound extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoOrdersFound({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(
                GetAsset.noOrder,
                gaplessPlayback: true,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Orders Yet!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "It looks like you haven't received any orders yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: onRefresh ?? null,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Refresh Orders",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
