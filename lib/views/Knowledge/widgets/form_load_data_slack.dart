import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FormLoadDataSlack extends StatefulWidget {
  const FormLoadDataSlack({super.key, required this.addNewData, required this.knowledgeId});
  final void Function(String newData) addNewData;
  final String knowledgeId;

  @override
  State<FormLoadDataSlack> createState() => _FormLoadDataSlackState();
}

class _FormLoadDataSlackState extends State<FormLoadDataSlack> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";
  String _enteredSlackWorkspace = "";
  String _enteredSlackBotToken = "";
  final String url = 'https://jarvis.cx/help/knowledge-base/connectors/slack/';

  void _saveFile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await Provider.of<KnowledgeBaseProvider>(context, listen: false)
          .uploadSlack(widget.knowledgeId,_enteredName, _enteredSlackWorkspace, _enteredSlackBotToken);

      widget.addNewData(_enteredName);
      Navigator.pop(context);
    }
  }

  Future<void> _openLink() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Không thể mở liên kết $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Add Unit",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          InkWell(
            onTap: _openLink,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Docs',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: Row(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://static-00.iconduck.com/assets.00/slack-icon-2048x2048-vhdso1nk.png",
                    width: 34,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons
                          .storage); // Hiển thị icon lỗi nếu không load được hình
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Slack",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Name',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input unit knowledge name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Slack Workspace',
                      hintText: 'Slack Workspace',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input slack workspace';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredSlackWorkspace = value!;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Slack Bot Token',
                      hintText: 'Slack Bot Token',
                      suffixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input slack bot token';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredSlackBotToken = value!;
                    },
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
