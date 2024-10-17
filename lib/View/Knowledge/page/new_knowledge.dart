import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/load_data_knowledge.dart';

class NewKnowledge extends StatefulWidget {
  const NewKnowledge({super.key});

  @override
  State<NewKnowledge> createState() => _NewKnowledgeState();
}

class _NewKnowledgeState extends State<NewKnowledge> {
  final _formKey = GlobalKey<FormState>();
  int accessOption = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tạo Bộ Tri Thức',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                // controller: nameController,
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
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Dịch giả chuyên nghiệp | Chuyên gia viết lách | Trợ lý mã',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              TextFormField(
                // controller: promptController,
                maxLines: 4,
                decoration: const InputDecoration(
                  // labelText: 'Prompt',
                  hintText: 'Nhập mô tả bộ tri thức...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Bạn là một dịch giả có kinh nghiệm với kỹ năng trong nhiều ngôn ngữ trên thế giới.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              const LoadDataKnowledge(
                arrFile: ["file1.pdf", "file2.pdf"],
                nameTypeData: "Nạp dữ liệu từ File",
                imageAddress:
                    'https://i0.wp.com/static.vecteezy.com/system/resources/previews/022/086/609/non_2x/file-type-icons-format-and-extension-of-documents-pdf-icon-free-vector.jpg?ssl=1',
              ),
              const SizedBox(height: 16),
              const LoadDataKnowledge(
                arrFile: ["drive1.com", "drive2.com"],
                nameTypeData: "Nạp dữ liệu từ Google Drive",
                imageAddress:
                    "https://static-00.iconduck.com/assets.00/google-drive-icon-1024x1024-h7igbgsr.png",
              ),
            ],
          ),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Xử lý tạo bot nếu tất cả các trường hợp hợp lệ
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Tạo Ngay"),
            ),
          ],
        ),
      ],
    );
  }
}
