import 'dart:developer';
import 'package:drawer_panel/WIDGETS/CATOGORIES/catogory_art_style.dart';
import 'package:flutter/material.dart';
import 'package:drawer_panel/FUNCTIONS/DATA_RETRIEVE_FN/get_catogories.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/asset_helper.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/catogory_model.dart';
import 'package:drawer_panel/PROVIDER/network_provider.dart';
import 'package:drawer_panel/WIDGETS/CATOGORIES/catogory_art_style.dart';
import 'package:drawer_panel/WIDGETS/helper_text.dart';
import 'package:drawer_panel/WIDGETS/lottie_animater.dart';
import 'package:drawer_panel/WIDGETS/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResinArtScreen extends StatefulWidget {
  const ResinArtScreen({super.key});

  @override
  State<ResinArtScreen> createState() => _ResinArtScreenState();
}

class _ResinArtScreenState extends State<ResinArtScreen> {
  final String categoryName = "Resin Art";
  late Stream<CategoryModel?> _categoryData;

  @override
  void initState() {
    super.initState();
    _categoryData = GetCatogoriesFN.getCategoryByName(categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const HelperText1(text: 'Resin Art Styles'),
          centerTitle: false,
        ),
        backgroundColor: Colors.grey[200],
        body: networkProvider.isConnected
            ? StreamBuilder<CategoryModel?>(
                stream: _categoryData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                        child: LottieAnimationWidget(
                            animationPath: GetAsset.lottie.loader));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No category found.'));
                  }

                  final category = snapshot.data!;
                  List<String> sortOptions = ["All Styles"];
                  List<ArtTypeModel> artStyles = [];

                  if (category.types.isNotEmpty) {
                    for (var type in category.types) {
                      if (type.name!.isNotEmpty) {
                        sortOptions.add(type.name!);
                      }
                      if (type != null) {
                        artStyles.add(type);
                      }
                    }
                  }
sortOptions = sortOptions.toSet().toList();
                  return ArtStyleScreen(
                    sortOptions: sortOptions,
                    artTypes: artStyles,
                  );
                },
              )
            : NoInternetWidget(onRetry: () async {
                await networkProvider.retry();
                _categoryData = GetCatogoriesFN.getCategoryByName(categoryName);
              }));
  }
}
