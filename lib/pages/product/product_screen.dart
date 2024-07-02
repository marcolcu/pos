import 'package:android_project/pages/product/partials/add_product_screen.dart';
import 'package:android_project/services/product_db_service.dart';
import 'package:flutter/material.dart';
import 'partials/edit_product_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductDbService dbService = ProductDbService();
  late Future<List<Map<String, dynamic>>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = dbService.getProducts();
  }

  void _editProduct(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(productId: id),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {
          futureProducts = dbService.getProducts(); // Perbarui daftar produk setelah pengeditan
        });
      }
    });
  }

  void _deleteProduct(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                int rowsAffected = await dbService.deleteProduct(id);
                if (rowsAffected > 0) {
                  setState(() {
                    futureProducts = dbService.getProducts(); // Perbarui daftar produk setelah penghapusan
                  });
                  // Tampilkan pesan atau notifikasi sukses
                } else {
                  // Tampilkan pesan atau notifikasi gagal
                }
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var product = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Selling Price: ${product['sellingPrice']}, Stock: ${product['stock']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editProduct(product['id']); // Panggil fungsi edit produk
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(product['id']); // Panggil fungsi hapus produk
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        tooltip: 'Options',
        child: Icon(Icons.more_vert),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Products'),
                onTap: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(), // Navigasi ke AddProductScreen
                    ),
                  ).then((result) {
                    if (result == true) {
                      setState(() {
                        futureProducts = dbService.getProducts(); // Perbarui daftar produk setelah menambahkan
                      });
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Products'),
                onTap: () {
                  // Implementasi logika hapus produk
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
