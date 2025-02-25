import 'dart:developer';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/VIEW/product_details_view.dart';
import 'package:drawer_panel/WIDGETS/CATOGORIES/catogory_cards.dart';
import 'package:flutter/material.dart';

class ArtStyleScreen extends StatefulWidget {
  final List<String> sortOptions;
  final List<ArtTypeModel> artTypes;

  const ArtStyleScreen({
    super.key,
    required this.sortOptions,
    required this.artTypes,
  });

  @override
  State<ArtStyleScreen> createState() => _ArtStyleScreenState();
}

class _ArtStyleScreenState extends State<ArtStyleScreen> {
  String _selectedSortOption = 'All Styles';
  late List<ArtTypeModel> _filteredArtTypes;

  @override
  void initState() {
    super.initState();
    _filteredArtTypes = widget.artTypes;
  }

  void _filterArtTypes() {
    if (_selectedSortOption == 'All Styles') {
      _filteredArtTypes = widget.artTypes;
    } else {
      _filteredArtTypes = widget.artTypes.where((artType) {
        return artType.name == _selectedSortOption;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.artTypes.toString(), name: "Art Types");
    Size size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(
                widget.sortOptions.length,
                (int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      side: const BorderSide(color: Colors.deepPurple),
                      disabledColor: Colors.grey,
                      label: Text(widget.sortOptions[index]),
                      selected:
                          widget.sortOptions[index] == _selectedSortOption,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedSortOption = widget.sortOptions[index];
                            _filterArtTypes();
                          }
                        });
                      },
                      selectedColor: Colors.deepPurple[400],
                      backgroundColor: Colors.white70,
                      labelStyle: TextStyle(
                        color: widget.sortOptions[index] == _selectedSortOption
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.70,
              ),
              itemCount: _filteredArtTypes.length,
              itemBuilder: (context, index) {
                final arts = _filteredArtTypes[index];
                final product = arts.product;

                return CatogoryTypeCard(
                  price:   product.drawingTypes![0].sizes![0].price.toString(),
                  title: product.title!,
                  offerPrice:
                      product.drawingTypes![0].sizes![0].offerPrice!.toString(),
                  img: product.images!.first,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsView(artTypeModel: arts)));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
