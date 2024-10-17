import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Bot/data/bots_data.dart';
import 'package:project_ai_chat/View/Bot/page/new_bot.dart';
import 'package:project_ai_chat/View/Bot/widgets/bot_card.dart';
import 'package:project_ai_chat/View/Bot/widgets/filter_button.dart';

class BotScreen extends StatelessWidget {
  const BotScreen({super.key});

  void _openAddBotDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const NewBot());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bots"),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(label: "Celebrity", isSelected: true),
                FilterButton(label: "My bots", isSelected: false),
                FilterButton(label: "Top", isSelected: false),
                FilterButton(label: "Models", isSelected: false),
              ],
            ),
            // const SizedBox(
            //   height: 36,
            //   child: FilterButtonList(),
            // ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: bots.length,
                itemBuilder: (context, index) {
                  return BotCard(bot: bots[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
