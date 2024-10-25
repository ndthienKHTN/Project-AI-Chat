import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormLoadDataWeb extends StatefulWidget {
  const FormLoadDataWeb({super.key, required this.addNewData});
  final void Function(String newData) addNewData;

  @override
  State<FormLoadDataWeb> createState() => _FormLoadDataWebState();
}

class _FormLoadDataWebState extends State<FormLoadDataWeb> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";

  void _saveFile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.addNewData(_enteredName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add Unit",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/5339/5339181.png",
                  width: 34,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons
                        .storage); // Hiển thị icon lỗi nếu không load được hình
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  "Website",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      hintText: 'Nhập tên',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Web Url',
                      hintText: 'Nhập Web Url',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: _saveFile,
              child: const Text("Tạo Ngay"),
            ),
          ],
        ),
      ],
    );
  }
}
