import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data.dart';

class LoadDataKnowledge extends StatefulWidget {
  const LoadDataKnowledge(
      {super.key,
      required this.arrFile,
      required this.nameTypeData,
      required this.imageAddress,
      required this.addNewData,
      required this.removeData});
  final List<String> arrFile;
  final String nameTypeData;
  final String imageAddress;
  final void Function(String newData) addNewData;
  final void Function(String newData) removeData;

  @override
  State<LoadDataKnowledge> createState() => _LoadDataKnowledgeState();
}

class _LoadDataKnowledgeState extends State<LoadDataKnowledge> {
  void _openDialogAddFile(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => FormLoadData(
              addNewData: _addNewFile,
            ));
  }

  void _addNewFile(String name) {
    widget.addNewData(name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft, // Align to the left
          child: Text(widget.nameTypeData),
        ),
        Column(
          children: widget.arrFile
              .map(
                (knowledge) => Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // const Icon(Icons.storage,
                        //     color: Colors.green, size: 30),
                        Image.network(
                          widget.imageAddress,
                          width: 34,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons
                                .storage); // Hiển thị icon lỗi nếu không load được hình
                          },
                        ),
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
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                widget.removeData(knowledge);
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
            _openDialogAddFile(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Upload'),
        ),
      ],
    );
  }
}
