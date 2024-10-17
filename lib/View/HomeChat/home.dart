import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BottomSheet/custom_bottom_sheet.dart';
import '../Menu/menu.dart';
import '../ToolWidget/tool.dart';

class HomeChat extends StatefulWidget {
  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _countToken = 50; //Token
  List<String> listAIItems = ['Bin AI', 'Monica', 'Chat GPT', 'Jarvis'];
  String selectedAIItem = 'Jarvis';
  bool _isOpenToolWidget = false;
  void _toggleToolVisibility() {
    setState(() {
      _isOpenToolWidget = !_isOpenToolWidget;
    });
  }
  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': _controller.text});
      _messages.add({'sender': 'bot', 'text': 'This is a bot response.'});
      _controller.clear();
      _countToken--;
    });
  }

  void updateSelectedAIItem(String newValue) {
    setState(() {
      listAIItems.remove(newValue); // Xóa item khỏi vị trí hiện tại
      listAIItems.add(newValue); // Thêm item vào cuối mảng
      selectedAIItem = newValue; // Cập nhật giá trị được chọn
    });
  }

  Widget _buildMessage(String sender, String message) {
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
        child: Text(
          message,
          style: TextStyle(color: isUser ? Colors.black : Colors.black),
        ),
      ),
    );
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
                          child: ListView.builder(
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return _buildMessage(
                                _messages[index]['sender']!,
                                _messages[index]['text']!,
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
                                                // style: TextStyle(
                                                //   fontSize: 15,
                                                // ),
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
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                    // Gọi hàm show bottom sheet từ file custom_bottom_sheet.dart
                                    CustomBottomSheet.show(context);
                                    },
                                    child: Text(
                                    'View all',
                                    style: TextStyle(fontSize: 20, color: Colors.blue),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        _messages.clear();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: 140,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 247, 250, 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập tin nhắn...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    // Dòng 3: Icon và nút send
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.image_rounded),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon:
                                          const Icon(Icons.camera_alt),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.email),
                                          onPressed: () {},
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
                                    '$_countToken',
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
                            )
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
