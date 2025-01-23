import 'package:drawer_panel/HELPERS/CONSTANTS/asset_helper.dart';
import 'package:drawer_panel/PROVIDER/image_downloader_provider.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/custom_button.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/download_button.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/mark_as_started_dialogue.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/order_details_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderedPictureScreen extends StatelessWidget {
  const OrderedPictureScreen({super.key});

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
                image: const DecorationImage(
                  image: AssetImage(GetAsset.gl1),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),
            const SizedBox(height: 10),
            Consumer<DownloadProvider>(builder: (context, provider, child) {
              return CustomButton(
                text: provider.isDownloading
                    ? "Downloading...${provider.progress}"
                    : "Download Image",
                onPressed: () {
                  provider.downloadImage(
                      "https://images.pexels.com/photos/11958343/pexels-photo-11958343.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      "sanju.jpg",context);
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
                    // color: Colors.red,
                    height: size.height,
                    width: size.width * .18,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        fit: BoxFit.cover,
                        GetAsset.dr1,
                        height: size.height,
                        width: size.width * .18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Wood burning"),
                      Text("Resin Art"),
                      Text("Wood burning"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  OrderDetailsDisplayer(label: "User Name:", value: "John Doe"),
                  OrderDetailsDisplayer(
                      label: "Drawing Name:", value: "Sunset Portrait"),
                  OrderDetailsDisplayer(label: "Size:", value: "20x30 inches"),
                  OrderDetailsDisplayer(
                      label: "Drawing Type:", value: "Watercolor"),
                  OrderDetailsDisplayer(
                      label: "Order Date:", value: "2025-01-22"),
                  OrderDetailsDisplayer(
                      label: "Order Time:", value: "15:45 PM"),
                  SizedBox(height: 10),
                  Text(
                    "Additional Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  OrderDetailsDisplayer(
                      label: "Order ID:", value: "ORD12345678"),
                  OrderDetailsDisplayer(
                      label: "Purchase ID:", value: "TRX987654321"),
                  OrderDetailsDisplayer(
                      label: "Product ID:", value: "PROD20230101"),
                  OrderDetailsDisplayer(
                      label: "Payment Method:", value: "Credit Card"),
                  OrderDetailsDisplayer(
                      label: "Order Status:", value: "Pending"),
                  OrderDetailsDisplayer(
                      label: "Contact Email:", value: "johndoe@example.com"),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shipping Address Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),

                      // User and Contact Details
                      OrderDetailsDisplayer(
                          label: "Name:", value: "Sanjay bro"),
                      OrderDetailsDisplayer(
                          label: "Phone:", value: "+9146466476"),
                      OrderDetailsDisplayer(
                          label: "Alternate Phone:", value: "+91"),
                      OrderDetailsDisplayer(
                          label: "Address Type:", value: "Home"),
                      SizedBox(height: 10), // Add spacing between sections

                      // Address Details
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      OrderDetailsDisplayer(
                          label: "House No:", value: "sbshjsjs"),
                      OrderDetailsDisplayer(label: "Road:", value: "sbssbs"),
                      OrderDetailsDisplayer(
                          label: "Landmark:", value: "hzbhzh"),
                      OrderDetailsDisplayer(label: "City:", value: "Bengaluru"),
                      OrderDetailsDisplayer(
                          label: "State:", value: "Karnataka"),
                      OrderDetailsDisplayer(label: "PIN:", value: "560087"),
                      SizedBox(height: 10),

                      // Order Metadata
                      Text(
                        "Order Metadata",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      OrderDetailsDisplayer(
                          label: "Created At:",
                          value: "January 1, 2025 at 5:31:37 PM"),
                      OrderDetailsDisplayer(
                          label: "Last Edited On:",
                          value: "January 1, 2025 at 5:31:37 PM"),
                      OrderDetailsDisplayer(
                          label: "Document ID:", value: "5s3jHK7G9ldzzGKyJBvx"),

                      SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Mark As Started",
              onPressed: () {
                showMarkAsStartedDialogue(context: context, onConfirm: () {});
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
