import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/services/prompt_service.dart';
import 'package:project_ai_chat/viewmodels/prompt-list-view-model.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';
import 'package:provider/provider.dart';

class PromptListWidget extends StatefulWidget {
  final String category;
  final String query;
  final bool isFavorite;
  final bool isPublic;

  const PromptListWidget({
    Key? key,
    required this.category,
    this.query = '',
    this.isFavorite = false,
    required this.isPublic,
  }) : super(key: key);

  @override
  _PromptListWidgetState createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  late Future<PromptList> _prompts;
  final Map<String, bool> _favoriteStates = {}; // Theo dõi trạng thái yêu thích
  bool isDeleting = false;

  @override
  void didUpdateWidget(PromptListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.category != widget.category ||
        oldWidget.query != widget.query ||
        oldWidget.isFavorite != widget.isFavorite ||
        oldWidget.isPublic != widget.isPublic) {
      setState(() {
        _prompts = _fetchPrompts(
          category: widget.category,
          query: widget.query,
          isFavorite: widget.isFavorite,
          isPublic: widget.isPublic,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _prompts = _fetchPrompts(
      category: widget.category,
      query: widget.query,
      isFavorite: widget.isFavorite,
      isPublic: widget.isPublic,
    );
  }

  Future<PromptList> _fetchPrompts({
    required String category,
    String query = '',
    bool isFavorite = false,
    required bool isPublic,
  }) {
    final promptService = context.read<PromptService>();
    final viewModel = PromptListViewModel(promptService);
    return viewModel.fetchPrompts(
      category: category,
      query: query,
      isFavorite: isFavorite,
      isPublic: isPublic,
    );
  }

  Future<bool> _toggleFavorite(String promptId, bool isFavorite) {
    final promptService = context.read<PromptService>();
    final viewModel = PromptListViewModel(promptService);
    return viewModel.toggleFavorite(promptId, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [FutureBuilder<PromptList>(
        future: _prompts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text('No prompts found.'));
          } else {
            final prompts = snapshot.data!;

            // Lưu trạng thái yêu thích ban đầu vào _favoriteStates
            for (var prompt in prompts.items) {
              _favoriteStates[prompt.id] ??= prompt.isFavorite ?? false;
            }

            return Expanded(
              child: ListView.builder(
                itemCount: prompts.total,
                itemBuilder: (context, index) {
                  final prompt = prompts.items[index];
                  final isFavorite = _favoriteStates[prompt.id] ?? false;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showPromptDetailsBottomSheet(
                                      context, prompt.title);
                                },
                                child: Text(
                                  prompt.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final success = await _toggleFavorite(
                                        prompt.id, isFavorite);

                                    if (success) {
                                      setState(() {
                                        _favoriteStates[prompt.id] = !isFavorite;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color:
                                        isFavorite ? Colors.yellow : Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10),
                                if (!widget
                                    .isPublic) // Hiển thị thùng rác nếu isPublic = false
                                  Row(children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isDeleting = true; // Bắt đầu quá trình xóa
                                        });
                                        final promptService =
                                            context.read<PromptService>();
                                        final viewModel =
                                            PromptListViewModel(promptService);
                                        final success = await viewModel
                                            .deletePrompt(prompt.id);
                                        if (success) {
                                          setState(() {
                                            _prompts = _fetchPrompts(
                                              category: widget.category,
                                              query: widget.query,
                                              isFavorite: widget.isFavorite,
                                              isPublic: widget.isPublic,
                                            );
                                          });

                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to delete prompt.')),
                                          );
                                        }
                                        setState(() {
                                          isDeleting = false; // Bắt đầu quá trình xóa
                                        });
                                      },
                                      child:
                                          Icon(Icons.delete_outline, color: Colors.grey),
                                    ),
                                    SizedBox(width: 10),
                                  ]),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showPromptDetailsBottomSheet(
                                        context, prompt.title);
                                  },
                                  child:
                                      Icon(Icons.arrow_right, color: Colors.grey),
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
      ),
        if (isDeleting)
          Positioned.fill(
            child: Container(
              //color: Colors.black.withOpacity(0.5), // Lớp màu mờ
              child: Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              ),
            ),
          ),
      ]
    );
  }

  void _showPromptDetailsBottomSheet(BuildContext context, String title) {
    // Logic để hiển thị bottom sheet
  }
}
