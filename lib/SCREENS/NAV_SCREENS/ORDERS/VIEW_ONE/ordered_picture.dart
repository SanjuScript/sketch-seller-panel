import 'dart:developer';

import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_order_fn.dart';
import 'package:drawer_panel/HELPERS/date_formater.dart';
import 'package:drawer_panel/MODEL/ORDER/address_model.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/PROVIDER/image_downloader_provider.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/custom_button.dart';
import 'package:drawer_panel/WIDGETS/CARDS/image_problem_card.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/image_problem.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/mark_as_started_dialogue.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/order_details_displayer.dart';
import 'package:drawer_panel/WIDGETS/address_builders.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderedPictureScreen extends StatelessWidget {
  final OrderDetailModel orderDetailModel;
  final bool showButton;
  const OrderedPictureScreen(
      {super.key, required this.orderDetailModel, this.showButton = true});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.bottomCenter,
              child: Hero(
                tag: orderDetailModel.adminToken,
                child: CustomCachedImageDisplayer(
                  width: size.width * 0.9,
                  height: size.height * 0.4,
                  imageUrl: orderDetailModel.selectedImage,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<DownloadProvider>(builder: (context, provider, child) {
              return CustomButton(
                text: provider.isDownloading
                    ? "Downloading...${provider.progress}"
                    : "Download Image",
                onPressed: () {
                  provider.downloadImage(
                      orderDetailModel.selectedImage,
                      "image_${DateTime.now().microsecondsSinceEpoch}.jpg",
                      context);
                },
                gradientColors: [Colors.deepPurple[100]!, Colors.deepPurple],
                icon: Icons.download,
                showLeading: !provider.isDownloading,
              );
            }),
            const SizedBox(height: 20),
            Container(
              height: size.height * .12,
              width: size.width * .90,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: size.height,
                    width: size.width * .18,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CustomCachedImageDisplayer(
                          imageUrl:
                              orderDetailModel.productDetails!.productImage,
                          height: size.height,
                          width: size.width * .18,
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          orderDetailModel.productDetails?.catName ??
                              "Unknown Product",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.85),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderDetailModel.productDetails!.drawingType ??
                              "No Type",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ImageIssueButton(
              orderID: orderDetailModel.orderId,
              onIssueSelected: (msg) async {
                UpdateOrderDetails.updateOrderProblem(
                    orderId: orderDetailModel.orderId,
                    problemMessage: msg,
                    nfToken: orderDetailModel.userDetails!.nfToken ?? '');
              },
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Information",
                    style: TextStyle(
                      fontSize: size.width * .06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OrderDetailsDisplayer(
                      label: "Buyer Name:",
                      value: orderDetailModel.userDetails!.fullName!),
                  OrderDetailsDisplayer(
                      label: "Drawing Name:",
                      value: orderDetailModel.productDetails!.catName),
                  OrderDetailsDisplayer(
                      label: "Size:",
                      value:
                          "${orderDetailModel.productDetails!.size!.height}x${orderDetailModel.productDetails!.size!.width} inches"),
                  OrderDetailsDisplayer(
                      label: "Drawing Type:",
                      value: orderDetailModel.productDetails!.drawingType),
                  OrderDetailsDisplayer(
                      label: "Paid Amount",
                      value:
                          "INR ${orderDetailModel.productDetails!.paidAmount.toString()}"),
                  OrderDetailsDisplayer(
                      label: "Order Date:",
                      value: DateFormatHelper.formatDate(
                          orderDetailModel.orderTime!)),
                  OrderDetailsDisplayer(
                      label: "Order Time:",
                      value: DateFormatHelper.formatTime(
                          orderDetailModel.orderTime!)),
                  const SizedBox(height: 10),
                  Text(
                    "Additional Details",
                    style: TextStyle(
                      fontSize: size.width * .06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OrderDetailsDisplayer(
                      label: "Order ID:", value: orderDetailModel.orderId),
                  OrderDetailsDisplayer(
                      label: "Payment ID:",
                      value: orderDetailModel.paymentModel!.paymentID!),
                  OrderDetailsDisplayer(
                      label: "Payment Method:",
                      value: orderDetailModel.transactionModel!.method),
                  OrderDetailsDisplayer(
                      label: "Order Status:", value: orderDetailModel.status),
                  OrderDetailsDisplayer(
                      label: "Contact Email:",
                      value: orderDetailModel.userDetails!.email!),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shipping Address Details",
                        style: TextStyle(
                          fontSize: size.width * .06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...AddressHelpers.buildAddressDetails(
                          orderDetailModel.address),
                      const SizedBox(height: 10),
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: size.width * .06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...AddressHelpers.buildFullAddress(
                          orderDetailModel.address),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (showButton)
              CustomButton(
                text: "Mark As Started",
                onPressed: () {
                  showMarkAsStartedDialogue(
                    context: context,
                    onConfirm: () {
                      log(orderDetailModel.userDetails!.uid.toString());
                      UpdateOrderDetails.updateTrackingStage(
                          orderDetailModel.userDetails!,
                          orderDetailModel.orderId,
                          "Drawing Started");
                      Navigator.pop(context);
                    },
                  );
                },
                gradientColors: [
                  Colors.deepOrangeAccent[100]!,
                  Colors.deepPurple
                ],
                icon: Icons.done_all,
                showLeading: true,
              ),
          ],
        ),
      ),
    );
  }
}
