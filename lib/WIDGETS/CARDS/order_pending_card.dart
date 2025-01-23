import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_ONE/ordered_picture.dart';
import 'package:flutter/material.dart';

class OrderPendingCard extends StatelessWidget {
  final String title;
  final String date;
  final String purchaserName;
  final String status;

  const OrderPendingCard({
    super.key,
    required this.title,
    required this.date,
    required this.purchaserName,
    this.status = "Pending",
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderedPictureScreen()));
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        height: size.height * .15,
        width: size.width * .95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Photo Placeholder
            Container(
              height: size.height * .10,
              width: size.width * .23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * .05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * .04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Purchaser Name
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        purchaserName,
                        style: TextStyle(
                          fontSize: size.width * .04,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: size.width * .04,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Status Tag
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
