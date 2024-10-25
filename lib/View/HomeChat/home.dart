import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/Account/pages/account_screent.dart';
import 'package:project_ai_chat/View/Bot/page/bot_screen.dart';
import '../../core/Widget/dropdown-button.dart';
import '../BottomSheet/custom_bottom_sheet.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/message-home-chat.dart';
import '../EmailChat/email.dart';
import 'Widgets/BottomNavigatorBarCustom/custom-bottom-navigator-bar.dart';
import 'Widgets/Menu/menu.dart';
import 'Widgets/tool.dart';
import 'package:project_ai_chat/ViewModel/ai-chat-list.dart';

import 'model/ai-logo-list.dart';



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
  bool _isOpenToolWidget = false;
  bool _isOpenDeviceWidget = false;
  int _selectedBottomItemIndex = 0;
  final FocusNode _focusNode = FocusNode();
  late List<AIItem> _listAIItem;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus ) {
        setState(() {
          _isOpenDeviceWidget = false;
        });
      }
    });
    _listAIItem = Provider.of<AIChatList>(context,listen: false).aiItems;
    selectedAIItem = _listAIItem.first.name;
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
  void _toggleToolVisibility() {
    setState(() {
      _isOpenToolWidget = !_isOpenToolWidget;
    });
  }
  void _toggleDeviceVisibility() {
    setState(() {
      _isOpenDeviceWidget = !_isOpenDeviceWidget;
    });
  }
  void _sendMessage() {
    if (_controller.text.isEmpty && _selectedImagePath == null) return;
    setState(() {
      if (_selectedImagePath != null) {
        Provider.of<MessageModel>(context, listen: false).addMessage({
          'sender': 'user',
          'image': _selectedImagePath!,
        });
        _selectedImagePath = null;
      } else {
        Provider.of<MessageModel>(context, listen: false).addMessage({
          'sender': 'user',
          'text': _controller.text,
        });
      }
      Provider.of<MessageModel>(context, listen: false).addMessage({
        'sender': 'bot',
        'text': 'This is a bot response.',
      });
      _controller.clear();
      _listAIItem.firstWhere((aiItem) => aiItem.name == selectedAIItem).tokenCount -= 1;

    });
  }
  void updateSelectedAIItem(String newValue) {
    setState(() {
      selectedAIItem = newValue;
      AIItem aiItem = _listAIItem.firstWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.removeWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.insert(0, aiItem);
    });
  }

  Widget _buildMessage(String sender, Map<String, String> message) {
    bool isUser = sender == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: message.containsKey('image') && message['image'] != null
            ? Image.file(File(message['image']!))
            : message.containsKey('text') && message['text'] != null
            ? Text(
          message['text']!,
          style: TextStyle(color: isUser ? Colors.black : Colors.black),
        )
            : SizedBox.shrink(),
      ),
    );
  }
  void _saveConversation() {
    Provider.of<MessageModel>(context, listen: false).saveConversation();
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
                          updateSelectedAIItem(newValue);}
                          },
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flash_on,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          _listAIItem.firstWhere((aiItem) => aiItem.name == selectedAIItem).tokenCount.toString(),
                          style: const TextStyle(
                              color: Color.fromRGBO(
                                  119, 117, 117, 1.0)),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: Provider.of<MessageModel>(context).messages.isEmpty ? null : _saveConversation,
                  ),
                  IconButton(
                      onPressed: () { _toggleToolVisibility(); }, icon: const Icon(Icons.more_horiz)),
                ],
              ),
            )
        ),
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
                                  final message = messageModel.messages[index];
                                  return _buildMessage(
                                    message['sender'] ?? 'unknown',
                                    message,
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
                              icon: _isOpenDeviceWidget ? const Icon(Icons.arrow_back_ios_new) : const Icon(Icons.arrow_forward_ios),
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
                                    MaterialPageRoute(builder: (context) => EmailComposer()),
                                  );
                                },
                              ),
                            ],
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
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
                                            contentPadding: EdgeInsets.only(left: 10, right: 10),
                                            hintText: (_selectedImagePath == null) ? 'Nhập tin nhắn...' : null,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        if (_selectedImagePath != null)
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey, width: 3),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Image.file(
                                                    File(_selectedImagePath!),
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    top: -15,
                                                    right: -15,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close,size: 20,color: Colors.black,),
                                                      onPressed: () {
                                                        setState(() {
                                                          _selectedImagePath = null;
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
                // Phần bên phải: Thanh công cụ
                if(_isOpenToolWidget) Tool(),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
      currentIndex: _selectedBottomItemIndex,
      onTap: _onTappedBottomItem,
    )
          );
  }
}
