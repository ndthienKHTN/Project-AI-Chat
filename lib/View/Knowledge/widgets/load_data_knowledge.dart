import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_confluence.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_ggdrive.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_slack.dart';
import 'package:project_ai_chat/View/Knowledge/widgets/form_load_data_web.dart';

class LoadDataKnowledge extends StatefulWidget {
  const LoadDataKnowledge({
    super.key,
    required this.addNewData,
    required this.removeData,
    required this.knowledgeId,
  });
  final String knowledgeId;
  final void Function(String newData) addNewData;
  final void Function(String newData) removeData;

  @override
  State<LoadDataKnowledge> createState() => _LoadDataKnowledgeState();
}

class _LoadDataKnowledgeState extends State<LoadDataKnowledge> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _options = [
    {
      'title': 'Local files',
      'subtitle': 'Upload pdf, docx, ...',
      'icon': Icons.folder
    },
    {
      'title': 'Google drive',
      'subtitle': 'Connect Google drive to get data',
      'icon': Icons.drive_folder_upload
    },
    {
      'title': 'Website',
      'subtitle': 'Connect Website to get data',
      'icon': Icons.public
    },
    {
      'title': 'Slack',
      'subtitle': 'Connect Slack to get data',
      'icon': Icons.chat
    },
    {
      'title': 'Confluence',
      'subtitle': 'Connect Confluence to get data',
      'icon': Icons.chat
    },
  ];

  void _handleOptionTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNewFile(String name) {
    widget.addNewData(name);
  }

  void _openDialogAddFile(BuildContext context) {
    if (_selectedIndex == 0) {
      showDialog(
        context: context,
        builder: (context) => FormLoadData(
          addNewData: _addNewFile,
          knowledgeId: widget.knowledgeId,
        ),
      );
    } else if (_selectedIndex == 1) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataGGDrive(
                addNewData: _addNewFile,
              ));
    } else if (_selectedIndex == 2) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataWeb(
                addNewData: _addNewFile,
              ));
    } else if (_selectedIndex == 3) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataSlack(
                addNewData: _addNewFile,
              ));
    } else if (_selectedIndex == 4) {
      showDialog(
          context: context,
          builder: (context) => FormLoadDataConfluence(
                addNewData: _addNewFile,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _options.length,
          itemBuilder: (context, index) {
            final option = _options[index];
            final bool isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () => _handleOptionTap(index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[100] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    option['icon'],
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  title: Text(
                    option['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Text(option['subtitle']),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _openDialogAddFile(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
