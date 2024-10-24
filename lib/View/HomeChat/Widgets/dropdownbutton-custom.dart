import 'package:flutter/material.dart';

class AIDropdown extends StatelessWidget {
  final String selectedAIItem;
  final List<String> listAIItems;
  final Map<String, int> aiTokenCounts;
  final ValueChanged<String?> onChanged;

  const AIDropdown({
    Key? key,
    required this.selectedAIItem,
    required this.listAIItems,
    required this.aiTokenCounts,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        child: DropdownButtonFormField<String>(
          value: listAIItems.contains(selectedAIItem) ? selectedAIItem : listAIItems.first,
          isExpanded: true,
          onChanged: onChanged,
          items: listAIItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Spacer(),
                  const Icon(Icons.flash_on, color: Colors.greenAccent, size: 12),
                  Text('${aiTokenCounts[value]}', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return listAIItems.map<Widget>((String value) {
              return Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}