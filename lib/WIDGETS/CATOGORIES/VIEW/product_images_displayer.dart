import 'package:drawer_panel/PROVIDER/product_slider_provider.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImagesDisplayer extends StatelessWidget {
  final int count;
  final List<String> imgs;
  const ProductImagesDisplayer({
    super.key,
    required this.count,
    required this.imgs,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductSliderProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        PageView.builder(
          controller: provider.createPageController(),
          itemCount: count,
          onPageChanged: provider.onPageChange,
          itemBuilder: (context, index) {
            return Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomCachedImageDisplayer(
                  imageUrl: imgs[index],
                  borderRadius: BorderRadius.circular(12),
                  height: size.height * .3,
                  width: double.infinity,
                ));
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .02,
              width: size.width * .25,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: SmoothPageIndicator(
                  controller: provider.createPageController(), // PageController
                  count:count,
                  effect: const WormEffect(
                    dotWidth: 8,
                    dotColor: Colors.white,
                    activeDotColor: Colors.teal,
                    dotHeight: 8,
                  ),
                  onDotClicked: (index) {
                    provider.navigateToPage(provider.createPageController(), index);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
