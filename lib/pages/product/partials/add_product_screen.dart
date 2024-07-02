import 'package:android_project/services/product_db_service.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final ProductDbService dbService = ProductDbService();

  void _addProduct() async {
    String name = _nameController.text.trim();
    double sellingPrice = double.tryParse(_sellingPriceController.text.trim()) ?? 0.0;
    double purchasePrice = double.tryParse(_purchasePriceController.text.trim()) ?? 0.0;
    int stock = int.tryParse(_stockController.text.trim()) ?? 0;

    await dbService.insertProduct(name, sellingPrice, purchasePrice, stock);
    Navigator.of(context).pop(true); // kembali ke layar sebelumnya dengan nilai true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _sellingPriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Selling Price',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _purchasePriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Purchase Price',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Stock',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
