import 'package:android_project/services/product_db_service.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;

  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ProductDbService dbService = ProductDbService();
  late TextEditingController _nameController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _purchasePriceController = TextEditingController();
    _stockController = TextEditingController();

    // Load existing product data
    _loadProductData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _purchasePriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _loadProductData() async {
    try {
      var product = await dbService.getProductById(widget.productId);
      _nameController.text = product['name'];
      _sellingPriceController.text = product['sellingPrice'].toString();
      _purchasePriceController.text = product['purchasePrice'].toString();
      _stockController.text = product['stock'].toString();
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  void _editProduct() async {
    String name = _nameController.text.trim();
    double sellingPrice = double.tryParse(_sellingPriceController.text.trim()) ?? 0.0;
    double purchasePrice = double.tryParse(_purchasePriceController.text.trim()) ?? 0.0;
    int stock = int.tryParse(_stockController.text.trim()) ?? 0;

    try {
      await dbService.updateProduct(widget.productId, name, sellingPrice, purchasePrice, stock);
      Navigator.of(context).pop(true); // Return success result
    } catch (e) {
      print('Error editing product: $e');
      // Handle error: display message or notification
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _sellingPriceController,
              decoration: InputDecoration(labelText: 'Selling Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _purchasePriceController,
              decoration: InputDecoration(labelText: 'Purchase Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _editProduct,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
