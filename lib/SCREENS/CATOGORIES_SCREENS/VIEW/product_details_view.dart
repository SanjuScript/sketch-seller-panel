import 'dart:developer';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/PROVIDER/VIEW/drawing_type_selector.dart';
import 'package:drawer_panel/PROVIDER/product_slider_provider.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/VIEW/analytics_screen.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/VIEW/editing_screen.dart';
import 'package:drawer_panel/WIDGETS/CATOGORIES/VIEW/analytics_cards.dart';
import 'package:drawer_panel/WIDGETS/CATOGORIES/VIEW/drawing_type_selector.dart';
import 'package:drawer_panel/WIDGETS/CATOGORIES/VIEW/product_images_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsView extends StatefulWidget {
  final ArtTypeModel artTypeModel;
  const ProductDetailsView({super.key, required this.artTypeModel});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late PageController pageController;

  void onPageChange(int index) {
    final provider = context.read<ProductSliderProvider>();
    provider.selectedIndex = index;
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductSliderProvider>();
    pageController = provider.createPageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.artTypeModel.product;
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title ?? "Product Details",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductEditingScreen(
                          artTypeModel: widget.artTypeModel)));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: ProductImagesDisplayer(
                count: product.images!.length,
                imgs: product.images!,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title ?? "Product Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<DrawingTypeProvider>(
              builder: (context, value, child) {
                log("Value : ${value.price}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.inOffer!
                          ? '₹${value.offerPrice.toStringAsFixed(2)}'
                          : '₹${value.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:
                            product.inOffer! ? Colors.red : Colors.deepPurple,
                      ),
                    ),
                    if (product.inOffer!)
                      Text(
                        '₹${value?.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            DrawingTypeSelector(product: product),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnalyticsCards(
                            title: "Total Orders",
                            value: (product.totalOrders ?? '0').toString()),
                        AnalyticsCards(
                            title: "Revenue",
                            value: "₹${(product.revenue ?? '0')}"),
                        AnalyticsCards(
                            title: "Reviews",
                            value: product.totalReviewCount.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AnalyticsScreen()));
                    },
                    icon: const Icon(Icons.next_plan),
                    label: const Text("See full overview"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Product Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? "No description availa ble",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Additional Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Art Type:", style: TextStyle(fontSize: 16)),
                Text(widget.artTypeModel.name!,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Category:", style: TextStyle(fontSize: 16)),
                Text(product.description ?? "Unknown",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
