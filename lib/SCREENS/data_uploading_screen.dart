import 'dart:io';

import 'package:drawer_panel/WIDGETS/UPLOAD_PAGE/custom_drop_menu.dart';
import 'package:drawer_panel/WIDGETS/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ProductUploadScreen extends StatefulWidget {
  @override
  _ProductUploadScreenState createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedType;
  bool _isAvailable = true;
  bool _isPopular = false;
  List<PlatformFile> _pickedFiles = [];
  bool _isUploading = false;

  final _categories = [
    'Wood Burning',
    "Blood Art",
    "Resin Art",
    "Blue Art",
    "Glass Art",
    "Sketch"
  ];
  final Map<String, List<String>> _types = {
    'Wood Burning': ['Without Color', 'With Resin', 'With Color and Resin'],
    'Blood Art': ['Pepper Drawing', 'Blood Art in Glass'],
    'Resin Art': [
      'Pendant',
      'Varmala preservation',
      'Rings',
      'All Material Preservation',
      'Clock'
    ],
    'Blue Art': [],
    'Glass Art': ['Realistic Pencil Drawing', 'Simple Pencil Drawing'],
    'Sketch': [],
  };

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      try {
        // Upload images to Firebase Storage
        List<String> imageUrls = [];
        for (PlatformFile file in _pickedFiles) {
          final ref = FirebaseStorage.instance.ref().child(
              'products/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
          await ref.putFile(File(file.path!));
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }

        // Prepare product data
        final productData = {
          'title': _titleController.text.trim(),
          'price': double.parse(_priceController.text),
          'offerPrice': _offerPriceController.text.isNotEmpty
              ? double.parse(_offerPriceController.text)
              : null,
          'imageUrl': imageUrls,
          'createdAt': Timestamp.now(),
          'isAvailable': _isAvailable,
          'isPopular': _isPopular,
        };

        // Save to Firestore
        final categoryDoc = FirebaseFirestore.instance
            .collection('categories')
            .doc(_selectedCategory);
        final typeDoc = categoryDoc.collection('types').doc(_selectedType);
        await typeDoc.collection('products').add(productData);

        // Show success toast/snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product uploaded successfully!')),
        );

        // Clear form
        setState(() {
          _formKey.currentState!.reset();
          _pickedFiles = [];
          _selectedCategory = null;
          _selectedType = null;
        });
      } catch (e) {
        // Show error toast/snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        leading:Icon(Icons.upload),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomDropdown<String>(
                label: 'Category',
                items: _categories,
                selectedValue: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedType = null; // Reset type when category changes
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 20),
              if (_selectedCategory != null)
                CustomDropdown<String>(
                  label: 'Type',
                  items: _types[_selectedCategory]!,
                  selectedValue: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value),
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
              SizedBox(
                height: 15,
              ),
              PremiumTextField(
                icon: Icons.title_rounded,
                labelText: 'Product Title',
                controller: _titleController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a product title' : null,
              ),
              const SizedBox(height: 16),
              PremiumTextField(
                icon: Icons.price_change_sharp,
                labelText: 'Price',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              const SizedBox(height: 16),
              PremiumTextField(
                icon: Icons.price_check_outlined,
                labelText: 'Offer Price (Optional)',
                controller: _offerPriceController,
                keyboardType: TextInputType.number,
                isOptional: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Images'),
                onPressed: _pickFiles,
              ),
              if (_pickedFiles.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _pickedFiles.map((file) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(file.path!),
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _uploadProduct,
                      child: const Text('Upload Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
