import 'package:flutter/material.dart';
import 'package:project_ai_chat/services/prompt_service.dart';
import 'package:project_ai_chat/viewmodels/prompt-list-view-model.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';
import 'package:provider/provider.dart';

class PromptListWidget extends StatefulWidget {
  @override
  _PromptListWidgetState createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildPromptsList3(context);
  }

  Widget _buildPromptsList3(BuildContext context) {
    final _promptService = context.read<PromptService>();
    final viewModel = PromptListViewModel(_promptService);

    return FutureBuilder<PromptList>(
      future: viewModel.fetchPrompts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
          return Center(child: Text('No prompts found.'));
        } else {
          final prompts = snapshot.data!;

          return Expanded(
            child: ListView.builder(
              itemCount: prompts.total,
              itemBuilder: (context, index) {
                final prompt = prompts.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Sử dụng Flexible để giới hạn độ dài của title và tránh việc icon bị che mất
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _showPromptDetailsBottomSheet(context, prompt.title);
                              },
                              child: Text(
                                prompt.title,
                                overflow: TextOverflow.ellipsis, // Cắt văn bản dài và hiển thị ...
                                maxLines: 1, // Giới hạn văn bản trong 1 dòng
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Gọi hàm để thêm vào yêu thích (ví dụ: gọi API để lưu lại trạng thái)
                                    //_toggleFavorite(prompt.id, !prompt.isFavorite!);
                                  });
                                },
                                child: Icon(
                                  prompt.isFavorite! ? Icons.star : Icons.star_border,
                                  color: prompt.isFavorite! ? Colors.yellow : Colors.grey,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(Icons.info_outline, color: Colors.grey),
                              SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showPromptDetailsBottomSheet(context, prompt.title);
                                },
                                child: Icon(Icons.arrow_right, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(prompt.description),
                      Divider(thickness: 1.2),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  void _showPromptDetailsBottomSheet(BuildContext context, String title) {
    // Logic để hiển thị bottom sheet
  }

  void _toggleFavorite(int promptId, bool isFavorite) {
    // Gọi hàm trong viewModel hoặc service để cập nhật trạng thái yêu thích của prompt
    // Ví dụ: _promptService.toggleFavorite(promptId, isFavorite);
  }
}
