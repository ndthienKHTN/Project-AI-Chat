import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Account/pages/account_screent.dart';
import 'package:project_ai_chat/View/Bot/page/bot_screen.dart';
import 'package:project_ai_chat/models/chat_exception.dart';
import '../../core/Widget/dropdown-button.dart';
import '../../viewmodels/aichat_list.dart';
import '../../viewmodels/message_homechat.dart';
import '../BottomSheet/custom_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../EmailChat/email.dart';
import 'Widgets/BottomNavigatorBarCustom/custom-bottom-navigator-bar.dart';
import 'Widgets/Menu/menu.dart';

import 'model/ai_logo.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  String? _selectedImagePath;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String selectedAIItem;
  bool _isOpenDeviceWidget = false;
  int _selectedBottomItemIndex = 0;
  final FocusNode _focusNode = FocusNode();
  late List<AIItem> _listAIItem;
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isOpenDeviceWidget = false;
        });
      }
    });
    _listAIItem = Provider.of<AIChatList>(context, listen: false).aiItems;
    selectedAIItem = _listAIItem.first.name;

    final aiItemName = _listAIItem.first.name;
    // Khởi tạo chat
    //createAiChat(aiItemName);
    Provider.of<MessageModel>(context, listen: false)
        .loadConversationHistory(_listAIItem.first.id);
  }

  void createAiChat(String aiItemName) async {
    // Khởi tạo chat
    final aiItem =
        _listAIItem.firstWhere((aiItem) => aiItem.name == aiItemName);
    Provider.of<MessageModel>(context, listen: false)
        .initializeChat(aiItem.id)
        .then((_) {
      // Cập nhật token count sau khi khởi tạo chat
      final remainingUsage =
          Provider.of<MessageModel>(context, listen: false).lastRemainingUsage;
      if (remainingUsage != null) {
        setState(() {
          aiItem.tokenCount = remainingUsage;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onTappedBottomItem(int index) {
    setState(() {
      _selectedBottomItemIndex = index;
    });
    if (index == 1) {
      CustomBottomSheet.show(context);
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BotScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreent()),
      );
    }
  }

  void _toggleDeviceVisibility() {
    setState(() {
      _isOpenDeviceWidget = !_isOpenDeviceWidget;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty && _selectedImagePath == null) return;

    try {
      final aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == selectedAIItem);

      // Gọi sendMessage từ MessageModel
      await Provider.of<MessageModel>(context, listen: false).sendMessage(
        _controller.text,
        aiItem,
      );

      // Cập nhật số token còn lại từ tin nhắn cuối cùng
      final messages =
          Provider.of<MessageModel>(context, listen: false).messages;
      if (messages.isNotEmpty && !messages.last['isError']) {
        setState(() {
          aiItem.tokenCount =
              messages.last['remainingUsage'] ?? aiItem.tokenCount;
        });
      }

      // Xóa nội dung input
      _controller.clear();

      // Xóa hình ảnh đã chọn (nếu có)
      if (_selectedImagePath != null) {
        setState(() {
          _selectedImagePath = null;
        });
      }
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is ChatException ? e.message : 'Có lỗi xảy ra khi gửi tin nhắn',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateSelectedAIItem(String newValue) {
    createAiChat(newValue);
    setState(() {
      selectedAIItem = newValue;
      AIItem aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.removeWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.insert(0, aiItem);
    });
  }

  Widget _buildMessage(String sender, Map<String, dynamic> message) {
    bool isUser = sender == 'user';
    bool isError = message['isError'] as bool? ?? false;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isError
              ? Colors.red[100]
              : (isUser ? Colors.blue[100] : Colors.grey[300]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: message.containsKey('image') && message['image'] != null
            ? Image.file(File(message['image'] as String))
            : message.containsKey('text') && message['text'] != null
                ? Text(
                    message['text'] as String,
                    style: TextStyle(
                      color: isError ? Colors.red : Colors.black,
                    ),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _openGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
        _isOpenDeviceWidget = false;
      });
    }
  }

  Future<void> _openCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
        _isOpenDeviceWidget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        body: Column(
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        //Open menu
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu)),
                  AIDropdown(
                    listAIItems: _listAIItem,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _updateSelectedAIItem(newValue);
                      }
                    },
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 235, 240, 244),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flash_on,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          _listAIItem
                              .firstWhere(
                                  (aiItem) => aiItem.name == selectedAIItem)
                              .tokenCount
                              .toString(),
                          style: const TextStyle(
                              color: Color.fromRGBO(119, 117, 117, 1.0)),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        createAiChat(selectedAIItem);
                      }),
                ],
              ),
            )),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context)
                      .unfocus(); // Ẩn bàn phím khi nhấn vào màn hình
                  if (_isOpenDeviceWidget) {
                    _toggleDeviceVisibility(); // Ẩn các nút chức năng
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, bottom: 10, right: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: Consumer<MessageModel>(
                                builder: (context, messageModel, child) {
                                  return ListView.builder(
                                    itemCount: messageModel.messages.length,
                                    itemBuilder: (context, index) {
                                      final message =
                                          messageModel.messages[index];
                                      return _buildMessage(
                                        message['sender'] as String? ??
                                            'unknown',
                                        message as Map<String, dynamic>,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: _isOpenDeviceWidget
                                      ? const Icon(Icons.arrow_back_ios_new)
                                      : const Icon(Icons.arrow_forward_ios),
                                  onPressed: _toggleDeviceVisibility,
                                ),
                                if (_isOpenDeviceWidget) ...[
                                  IconButton(
                                    icon: const Icon(Icons.image_rounded),
                                    onPressed: _openGallery,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: _openCamera,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.email),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmailComposer()),
                                      );
                                    },
                                  ),
                                ],
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            TextField(
                                              focusNode: _focusNode,
                                              controller: _controller,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                hintText:
                                                    (_selectedImagePath == null)
                                                        ? 'Nhập tin nhắn...'
                                                        : null,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                            if (_selectedImagePath != null)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Image.file(
                                                        File(
                                                            _selectedImagePath!),
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Positioned(
                                                        top: -15,
                                                        right: -15,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _selectedImagePath =
                                                                  null;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: _sendMessage,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedBottomItemIndex,
          onTap: _onTappedBottomItem,
        ));
  }
}
