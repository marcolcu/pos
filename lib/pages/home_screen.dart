import 'package:android_project/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:android_project/item_model.dart';
import 'package:android_project/services/test_db_service.dart';
import '../add_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TestDbService dbService = TestDbService();
  late Future<List<ItemModel>> futureItems;
  int _currentIndex = 0; // Indeks untuk BottomNavigationBar

  @override
  void initState() {
    super.initState();
    futureItems = dbService.getItem();
  }

  void _navigateToAddItem(BuildContext context, [ItemModel? item]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
          dbService: dbService,
          item: item,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        futureItems = dbService.getItem();
      });
    }
  }

  void _refreshItems() {
    setState(() {
      futureItems = dbService.getItem();
    });
  }

  void _logout() {
    // Implementasi logika logout di sini
    // Misalnya menghapus data sesi pengguna dan navigasi kembali ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshItems,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<ItemModel>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              return ListTile(
                title: Text(data.title),
                subtitle: Text(data.description),
                onTap: () => _navigateToAddItem(context, data),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddItem(context),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
