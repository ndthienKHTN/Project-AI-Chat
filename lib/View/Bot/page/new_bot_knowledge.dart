import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/Provider/KnowledgeBaseProvider.dart';
import 'package:provider/provider.dart';

class NewBotKnowledge extends StatelessWidget {
  const NewBotKnowledge({super.key, required this.arrKnowledgeAdded});
  final List<String> arrKnowledgeAdded;

  void _addKnowledge(BuildContext context, String nameKnowledge) {
    Navigator.of(context).pop(nameKnowledge);
  }

  @override
  Widget build(BuildContext context) {
    final arrKnowledge =
        Provider.of<KnowledgeBaseProvider>(context, listen: false)
            .knowledgeBases
            .where((element) => !arrKnowledgeAdded.contains(element));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Publish to',
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
            Icons.warning,
            color: Colors.red,
            size: 30,
          ),
          const Text(
            'By publishing your bot on the following platforms, you fully understand and agree to abide by Terms of service for each publishing channel.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          const Text("Bộ dữ liệu tri thức"),
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
                                knowledge,
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
                                    _addKnowledge(context, knowledge);
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