import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadDataKnowledge extends StatelessWidget {
  const LoadDataKnowledge(
      {super.key, required this.arrFile, required this.nameTypeData, required this.imageAddress});
  final List<String> arrFile;
  final String nameTypeData;
  final String imageAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft, // Align to the left
          child: Text(nameTypeData),
        ),
        Column(
          children: arrFile
              .map(
                (knowledge) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // const Icon(Icons.storage,
                        //     color: Colors.green, size: 30),
                        Image.network(
                          imageAddress,
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
          label: const Text('Upload File'),
        ),
      ],
    );
  }
}
