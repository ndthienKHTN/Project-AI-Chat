import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/data/knowledges_data.dart';
import 'package:project_ai_chat/View/Knowledge/page/new_knowledge.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/knowledge_card.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  void _openAddBotDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const NewKnowledge());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Knowledges",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openAddBotDialog(context);
            },
            icon: const Icon(Icons.add),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 60, 56, 56),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: knowledges.length,
                itemBuilder: (context, index) {
                  return KnowledgeCard(knowledge: knowledges[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
