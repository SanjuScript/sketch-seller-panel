import 'package:cached_network_image/cached_network_image.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';

class CatogoryTypeCard extends StatelessWidget {
  final String price;
  final String title;
  final String img;
  final String offerPrice;
  final void Function()? onTap;

  const CatogoryTypeCard(
      {super.key,
      required this.price,
      this.onTap,
      required this.title,
      required this.offerPrice,
      required this.img});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            SizedBox(
              height: size.height * .20,
              width: size.width,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: CustomCachedImageDisplayer(
                  imageUrl: img,
                  height: size.height * .20,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  width: size.width,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                if (true)
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 5),
                Text(
                  offerPrice,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Offer Tag or Placeholder
          ],
        ),
      ),
    );
  }
}
