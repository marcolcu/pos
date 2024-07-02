import 'package:flutter/material.dart';
import 'package:android_project/services/test_db_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:android_project/item_model.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.dbService, this.item});

  final TestDbService dbService;
  final ItemModel? item;

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
    }
  }

  Future<void> _saveItem() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Both title and description are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (widget.item != null) {
      await widget.dbService.updateItem(widget.item!.id, _titleController.text, _descriptionController.text);
    } else {
      await widget.dbService.addItem(_titleController.text, _descriptionController.text);
    }

    Fluttertoast.showToast(
      msg: "Item saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Enter title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Enter description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
