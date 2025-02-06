import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_TWO/order_updating_screen.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';

class OrderProcessorCard extends StatelessWidget {
  final OrderDetailModel orderDetailModel;
  final bool forDelivery;
  const OrderProcessorCard(
      {super.key, required this.orderDetailModel, this.forDelivery = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderUpdatingScreen(orderDetailModel: orderDetailModel)));
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
              imageUrl: orderDetailModel.selectedImage,
              height: size.height * .09,
              width: size.width * .20,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To: ${orderDetailModel.userDetails!.fullName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.brush_outlined,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${orderDetailModel.productDetails!.catName}\n${orderDetailModel.productDetails!.drawingType} ",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  if (forDelivery) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        Text(
                          "Delivered",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 16),
                        ),
                      ],
                    )
                  ] else ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Status: ${orderDetailModel.tracking!.stage}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Text(
                    forDelivery
                        ? "Delivered on ${DateFormatHelper.formatDateTime(orderDetailModel.tracking!.updatedAt!)}"
                        : 'Last Updated: ${DateFormatHelper.formatDateTime(orderDetailModel.tracking!.updatedAt!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!forDelivery)
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
