import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/bot_request.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';

import 'package:project_ai_chat/View/Bot/page/new_bot_knowledge.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:provider/provider.dart';

class EditBot extends StatefulWidget {
  const EditBot({super.key, required this.editBot, required this.bot});
  final void Function(BotRequest newBot) editBot;
  final BotRequest bot;

  @override
  State<EditBot> createState() => _NewBotState();
}

class _NewBotState extends State<EditBot> {
  final _formKey = GlobalKey<FormState>();
  List<String> _arrKnowledge = [];

  //TextFormField
  String _enteredName = "";
  String _enteredPrompt = "";
  String _enteredDescription = "";

  void _openAddKnowledgeDialog(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => NewBotKnowledge(arrKnowledgeAdded: _arrKnowledge),
    );

    if (result != null) {
      setState(() {
        _arrKnowledge.add(result);
      });
    }
  }

  void _handleDeleteKnowledge(String name) {
    setState(() {
      _arrKnowledge.remove(name);
    });
  }

  @override
  void initState() {
    super.initState();
    _enteredName = widget.bot.assistantName;
    _enteredPrompt = widget.bot.instructions!;
    _enteredDescription = widget.bot.description!;
  }

  void _saveBot() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // information edit bot
      widget.editBot(
          BotRequest(
            assistantName: _enteredName,
            instructions: _enteredPrompt,
            description: _enteredDescription,
          )
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final arrKnowledge =
    //     Provider.of<KnowledgeBaseProvider>(context, listen: false)
    //         .knowledgeBases;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chỉnh sửa Bot",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin cơ bản',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                          labelText: 'Name',
                          hintText: 'Enter a AI Bot\'s Name...',
                          suffixIcon: Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      const Text(
                        'Example: Professional Translator | Writing Expert | Code Assistant',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _enteredDescription,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter a description...',
                          suffixIcon: Icon(Icons.description),
                        ),
                        onSaved: (value) {
                          _enteredDescription = value ?? "";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        initialValue: _enteredPrompt,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Prompt',
                          hintText: 'Enter a AI Bot\'s Prompt Content...',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _enteredPrompt = value ?? "";
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Example: You are an experienced translator with skills in multiple languages worldwide.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      const Text("Bộ dữ liệu tri thức"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                iconSize: 20,
                                                color: Colors.green,
                                                onPressed: () {
                                                  // Handle copy action
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                iconSize: 20,
                                                color: Colors.red,
                                                onPressed: () {
                                                  _handleDeleteKnowledge(
                                                      knowledge);
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
                          const SizedBox(
                            height: 6,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _openAddKnowledgeDialog(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 1, color: Colors.blue),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Đảm bảo nút không chiếm toàn bộ chiều ngang
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                    width: 8), // Khoảng cách giữa icon và text
                                Text(
                                  'Add Knowledge',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveBot,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: const Text(
                          "Chỉnh sửa",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));

    //   actions: [
    //   ],
    // );
  }
}
