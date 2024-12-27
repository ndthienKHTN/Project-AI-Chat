import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/bot_request.dart';

class NewBot extends StatefulWidget {
  const NewBot({super.key, required this.addBot});
  final void Function(BotRequest newBot) addBot;

  @override
  State<NewBot> createState() => _NewBotState();
}

class _NewBotState extends State<NewBot> {
  final _formKey = GlobalKey<FormState>();

  //TextFormField
  String _enteredName = "";
  String _enteredPrompt = "";
  String _enteredDescription = "";

  void _saveBot() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.addBot(
        BotRequest(
            assistantName: _enteredName,
            instructions: _enteredPrompt,
            description: _enteredDescription,
      ));
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
                    'Tạo Bot',
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
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: const BorderSide(width: 1, color: Colors.orange)),
              child: const Text(
                "Huỷ",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveBot,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                "Tạo ngay",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
