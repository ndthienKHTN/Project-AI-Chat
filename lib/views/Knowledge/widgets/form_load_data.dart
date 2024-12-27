import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/services/analytics_service.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FormLoadData extends StatefulWidget {
  const FormLoadData(
      {super.key, required this.addNewData, required this.knowledgeId});
  final void Function(String newData) addNewData;
  final String knowledgeId;

  @override
  State<FormLoadData> createState() => _FormLoadDataState();
}

class _FormLoadDataState extends State<FormLoadData> {
  String _fileName = "";
  File? _selectedFile;
  final String url = 'https://jarvis.cx/help/knowledge-base/connectors/file/';

  void _saveFile() async {
    if (_selectedFile == null || _fileName == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose file before upload')),
      );
      return;
    }
    await Provider.of<KnowledgeBaseProvider>(context, listen: false)
        .uploadLocalFile(_selectedFile!, widget.knowledgeId);

    AnalyticsService().logEvent(
      "upload_file",
      {
        "name": _fileName,
      },
    );
    widget.addNewData(_fileName);
    Navigator.pop(context);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Cho phép tất cả loại file
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    } else {
      // Người dùng hủy chọn file
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
                    "https://icon-library.com/images/files-icon-png/files-icon-png-10.jpg",
                    width: 34,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons
                          .storage); // Hiển thị icon lỗi nếu không load được hình
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Local File",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pickFile,
                        icon: const Icon(
                          Icons.cloud_upload,
                          size: 80,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Click to this area to upload file',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_selectedFile != null) Text('File đã chọn: $_fileName'),
            const SizedBox(height: 16),
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
