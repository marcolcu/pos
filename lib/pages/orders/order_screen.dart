import 'package:android_project/services/order_db_service.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderDbService _orderDbService = OrderDbService();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final orders = await _orderDbService.getOrders();
    setState(() {
      _orders = orders;
    });
  }

  void _addOrder() async {
    await _orderDbService.insertOrder("Sample Product", 1, "Sample Member", 10.0);
    _loadOrders();
  }

  void _deleteOrder(int id) async {
    await _orderDbService.deleteOrder(id);
    _loadOrders();
  }

  void _updateOrder(int id) async {
    await _orderDbService.updateOrder(id, "Updated Product", 2, "Updated Member", 20.0);
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return ListTile(
            title: Text(order['product']),
            subtitle: Text('Quantity: ${order['quantity']} - Total Price: ${order['totalPrice']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateOrder(order['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteOrder(order['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrder,
        child: Icon(Icons.add),
      ),
    );
  }
}
