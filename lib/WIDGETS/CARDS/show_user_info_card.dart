import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/ORDERS/VIEW_ONE/ordered_picture.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';

class ShowUserInfoCard extends StatelessWidget {
  final OrderDetailModel orderDetailModel;
  const ShowUserInfoCard({super.key, required this.orderDetailModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderedPictureScreen(
                      orderDetailModel: orderDetailModel,
                      showButton: false,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(10),
        height: size.height * .10,
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
            CircleAvatar(
              radius: size.width * .07,
              child: Hero(
                tag: orderDetailModel.adminToken,
                child: CustomCachedImageDisplayer(
                  imageUrl: orderDetailModel.selectedImage,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              "See more details",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
