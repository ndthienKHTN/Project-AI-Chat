import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:project_ai_chat/viewmodels/bot_view_model.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:provider/provider.dart';

class NewBotKnowledge extends StatelessWidget {
  const NewBotKnowledge({super.key});

  void _addKnowledge(BuildContext context, String knowledgeId) {
    Provider.of<BotViewModel>(context, listen: false).importKnowledge(knowledgeId);
    Navigator.of(context).pop(knowledgeId);
  }

  @override
  Widget build(BuildContext context) {
    final botModel = context.read<BotViewModel>();

    // final arrKnowledge =
    //     Provider.of<KnowledgeBaseProvider>(context, listen: false)
    //         .knowledgeBases
    //         .where((element) => !botModel.knowledgeList.contains(element.id))
    //         .map((element) => element.id).toList();

    final List<Knowledge> arrKnowledge = Provider.of<KnowledgeBaseProvider>(context, listen: false).knowledgeBases
        .where((element) => !botModel.knowledgeList.any((item) => item.id == element.id))
        .toList();


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Thêm bộ dữ liệu tri thức',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Icon(
            Icons.addchart,
            color: Colors.blue,
            size: 30,
          ),
          const SizedBox(height: 20),
          Column(children: [
            Column(
              children: arrKnowledge
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
                                knowledge.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  iconSize: 20,
                                  color: Colors.blue,
                                  onPressed: () {
                                    _addKnowledge(context, knowledge.id);

                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ])
        ],
      ),
    );
  }
}
