import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_ONE/ordered_picture.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OrderPendingCard extends StatelessWidget {
  final OrderDetailModel orderDetailModel;

  const OrderPendingCard({
    Key? key,
    required this.orderDetailModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderedPictureScreen(orderDetailModel: orderDetailModel),
          ),
        );
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomCachedImageDisplayer(
                  height: size.height * .10,
                  width: size.width * .23,
                  imageUrl: orderDetailModel.productDetails?.productImage ?? '',
                  borderRadius: BorderRadius.circular(12),
                ),
                Positioned(
                  left: 10,
                  top: 8,
                  child: Transform.rotate(
                    angle: -pi / 12,
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: orderDetailModel.adminToken,
                      child: CustomCachedImageDisplayer(
                        height: size.height * .09,
                        width: size.width * .22,
                        imageUrl: orderDetailModel.selectedImage ?? '',
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        orderDetailModel.productDetails?.catName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.width * .05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          orderDetailModel.status ?? '',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        orderDetailModel.userDetails?.fullName ?? '',
                        style: TextStyle(
                          fontSize: size.width * .04,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        orderDetailModel.orderTime != null
                            ? DateFormatHelper.formatDateWithTime(
                                orderDetailModel.orderTime!)
                            : '',
                        style: TextStyle(
                          fontSize: size.width * .04,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
