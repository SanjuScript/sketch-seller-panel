import 'package:drawer_panel/MODEL/DATA/product_model.dart';
import 'package:drawer_panel/PROVIDER/VIEW/drawing_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingTypeSelector extends StatelessWidget {
  final Product product;

  const DrawingTypeSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    Future.delayed(Duration.zero, () {
      final provider = Provider.of<DrawingTypeProvider>(context, listen: false);
      provider.updatePriceAndOffer(product);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: product.drawingTypes!.asMap().entries.map((entry) {
              final index = entry.key;
              final drawingType = entry.value;

              return InkWell(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: () {
                  Provider.of<DrawingTypeProvider>(context, listen: false)
                      .selectedDrawingTypeIndex = index;

                  Provider.of<DrawingTypeProvider>(context, listen: false)
                      .updatePriceAndOffer(product);
                },
                child: Consumer<DrawingTypeProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      key: ValueKey(drawingType),
                      height: size.height * .055,
                      width: size.width * .33,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: provider.selectedDrawingTypeIndex == index
                            ? Colors.teal
                            : Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          drawingType.type!,
                          style: TextStyle(
                            color: provider.selectedDrawingTypeIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Consumer<DrawingTypeProvider>(
          builder: (context, provider, child) {
            return provider.selectedDrawingTypeIndex != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: product
                          .drawingTypes![provider.selectedDrawingTypeIndex!]
                          .sizes!
                          .asMap()
                          .entries
                          .map((sizeEntry) {
                        final sizeIndex = sizeEntry.key;
                        final size = sizeEntry.value;

                        return InkWell(
                          overlayColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          onTap: () {
                            provider.selectedSizeIndex = sizeIndex;
                            provider.updatePriceAndOffer(product);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: provider.selectedSizeIndex == sizeIndex
                                  ? Colors.blue
                                  : Colors.grey,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '${size.length} x ${size.width} inches',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
