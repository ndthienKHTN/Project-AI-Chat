import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Model/message-model.dart';
import '../EmailTab/email.dart';
import '../Menu/menu.dart';
import '../ToolWidget/tool.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  //final List<Map<String, String>> _messages = [];
  String? _selectedImagePath;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _countToken = 50; //Token
  List<String> listAIItems = ['Bin AI', 'Monica', 'Chat GPT', 'Jarvis'];
  String selectedAIItem = 'Jarvis';
  bool _isOpenToolWidget = false;
  Map<String, int> aiTokenCounts = {
    'Bin AI': 50,
    'Monica': 60,
    'Chat GPT': 70,
    'Jarvis': 80,
  };
  void _toggleToolVisibility() {
    setState(() {
      _isOpenToolWidget = !_isOpenToolWidget;
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
      _countToken--;
    });
  }
  void updateSelectedAIItem(String newValue) {
    setState(() {
      listAIItems.remove(newValue);
      listAIItems.add(newValue);
      selectedAIItem = newValue;
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
      });
    }
  }
  Future<void> _openCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
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
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        //Open menu
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu)),
                  const Text(
                    'Bin AI',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                      onPressed: () { _toggleToolVisibility(); }, icon: const Icon(Icons.more_horiz)),
                ],
              ),
            )),
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // Ẩn bàn phím khi nhấn vào màn hình
            },
            child: Row(
              children: [
                // Phần bên trái: Giao diện chat chính
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
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    color:
                                    Color.fromRGBO(246, 247, 250, 1.0),
                                    width: 120,
                                    height: 45,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedAIItem,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          updateSelectedAIItem(newValue);
                                        }
                                      },
                                      items: listAIItems
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                              ),
                                            );
                                          }).toList(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.light_mode_sharp)),
                                  Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: Provider.of<MessageModel>(context).messages.isEmpty ? null : _saveConversation,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 50,
                                  maxHeight: 140,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 247, 250, 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (_selectedImagePath != null)
                                          Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey, width: 4), // Add border here
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Image.file(
                                                  File(_selectedImagePath!),
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                right: -12,
                                                top: -12,
                                                child: IconButton(
                                                  icon: Icon(Icons.close,size: 20,),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedImagePath = null;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        Expanded(
                                          child: TextField(
                                            controller: _controller,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintText: (_selectedImagePath == null) ? 'Nhập tin nhắn...' : null,
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Dòng 3: Icon và nút send
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
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
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: _sendMessage,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 247, 250, 1.0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flash_on,
                                    color: Colors.greenAccent,
                                  ),
                                  Text(
                                    '${aiTokenCounts[selectedAIItem]}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            161, 156, 156, 1.0)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upgrade',
                              style: TextStyle(
                                color: Color.fromRGBO(160, 125, 220, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.wallet_giftcard,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.heart_broken,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.breakfast_dining,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.dangerous,
                            ),
                          ],
                        )
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
    )
          );
  }
}
