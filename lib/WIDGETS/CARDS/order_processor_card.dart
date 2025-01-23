import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_TWO/order_updating_screen.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';

class OrderProcessorCard extends StatelessWidget {
  const OrderProcessorCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderUpdatingScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        height: size.height * .15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomCachedImageDisplayer(
              imageUrl:
                  "https://images.pexels.com/photos/30349920/pexels-photo-30349920/free-photo-of-woman-with-straw-hat-entering-white-archway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              height: size.height * .09,
              width: size.width * .20,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To: John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Product Name',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse,
                        color: Colors.orangeAccent,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Status: In Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Last Updated: 2023-01-20 10:00',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Action Button
            Container(
              height: size.height * 0.05,
              width: size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
