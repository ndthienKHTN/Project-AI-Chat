import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Bot/model/bot.dart';

class EditBot extends StatefulWidget {
  const EditBot({super.key, required this.editBot, required this.bot});
  final void Function(Bot newBot) editBot;
  final Bot bot;

  @override
  State<EditBot> createState() => _NewBotState();
}

class _NewBotState extends State<EditBot> {
  final _formKey = GlobalKey<FormState>();
  final _arrKnowledge = ["knowledge1", "knowledge2"];
  int _accessOption = 1;

  //TextFormField
  String _enteredName = "";
  String _enteredPrompt = "";

  @override
  void initState() {
    super.initState();
    _enteredName = widget.bot.name;
    _enteredPrompt = widget.bot.prompt;
    _accessOption = widget.bot.isPublish ? 1 : 2;
  }

  void _saveBot() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // information edit bot
      widget.editBot(
        Bot(
          name: _enteredName,
          prompt: _enteredPrompt,
          team: widget.bot.team,
          imageUrl: widget.bot.imageUrl,
          isPublish: _accessOption == 1 ? true : false,
        ),
      );
      Navigator.pop(context);
    }
  }

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
                    'Chỉnh sửa Bot',
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
              const Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.add, size: 30),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                // controller: nameController,
                initialValue: _enteredName,
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
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Dịch giả chuyên nghiệp | Chuyên gia viết lách | Trợ lý mã',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _enteredPrompt,
                maxLines: 4,
                decoration: const InputDecoration(
                  // labelText: 'Prompt',
                  hintText: 'Nhập nội dung prompt...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập prompt';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPrompt = value!;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ví dụ: Bạn là một dịch giả có kinh nghiệm với kỹ năng trong nhiều ngôn ngữ trên thế giới.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _accessOption,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Publish'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Private'),
                  ),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _accessOption = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Quyền truy cập',
                ),
              ),
              const SizedBox(height: 16),
              const Text("Bộ dữ liệu tri thức"),
              Column(
                children: [
                  Column(
                    children: _arrKnowledge
                        .map(
                          (knowledge) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.storage,
                                      color: Colors.green, size: 30),
                                  // Image.network(
                                  //   'https://img.freepik.com/premium-vector/isometric-cloud-database-cloud-computing-file-cloud-storage-modern-technologies-vector-illustration_561158-2678.jpg',
                                  //   width: 30,
                                  //   errorBuilder: (context, error, stackTrace) {
                                  //     return const Icon(Icons
                                  //         .storage); // Hiển thị icon lỗi nếu không load được hình
                                  //   },
                                  // ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      knowledge,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        iconSize: 20,
                                        onPressed: () {
                                          // Handle copy action
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        iconSize: 20,
                                        onPressed: () {
                                          // Handle delete action
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Add Knowledge action
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Knowledge'),
                  ),
                ],
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
              onPressed: _saveBot,
              child: const Text("Chỉnh sửa"),
            ),
          ],
        ),
      ],
    );
  }
}
