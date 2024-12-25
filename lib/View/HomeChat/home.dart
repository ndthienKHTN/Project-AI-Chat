import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_ai_chat/View/Account/pages/account_screent.dart';
import 'package:project_ai_chat/View/Bot/page/bot_screen.dart';
import 'package:project_ai_chat/core/Widget/chat_widget.dart';
import 'package:project_ai_chat/models/response/my_aibot_message_response.dart';
import 'package:project_ai_chat/utils/exceptions/chat_exception.dart';
import 'package:project_ai_chat/models/response/message_response.dart';
import 'package:project_ai_chat/viewmodels/auth_view_model.dart';
import 'package:project_ai_chat/viewmodels/bot_view_model.dart';
import 'package:project_ai_chat/viewmodels/knowledge_base_view_model.dart';
import 'package:project_ai_chat/viewmodels/prompt_list_view_model.dart';
import '../../core/Widget/dropdown-button.dart';
import '../../viewmodels/aichat_list_view_model.dart';
import '../../viewmodels/homechat_view_model.dart';
import '../BottomSheet/Widgets/PromptDetailsBottomSheet/prompt_details_bottom_sheet.dart';
import '../BottomSheet/custom_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../EmailChat/email.dart';
import 'Widgets/BottomNavigatorBarCustom/bottom_navigation.dart';
import 'Widgets/Menu/menu.dart';
import '../../models/ai_logo.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isOpenDeviceWidget = false;
  int _selectedBottomItemIndex = 0;
  List<String>? _imagePaths;
  late List<AIItem> _listAIItem;
  late String selectedAIItem;
  bool _hasText = false;
  bool _showSlash = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    //Lắng nghe ô nhập dữ liệu
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
    //Bắt sự lắng nghe khi focus vào ô nhập dữ liệu
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isOpenDeviceWidget = false;
        });
      }
    });

    // lấy thông tin user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
    });

    final aiChatList = Provider.of<AIChatList>(context, listen: false);
    _listAIItem = aiChatList.aiItems;
    selectedAIItem = aiChatList.selectedAIItem.name;
    // Khởi tạo chat với AIItem được chọn
    final aiItem =
        _listAIItem.firstWhere((aiItem) => aiItem.name == selectedAIItem);
    // Lấy danh sách conversation và load conversation gần nhất
    Provider.of<MessageModel>(context, listen: false)
        .fetchAllConversations(aiItem.id, 'dify')
        .then((_) async {
      await Provider.of<MessageModel>(context, listen: false)
          .checkCurrentConversation(aiItem.id);
    });
    //Hiển thị token
    Provider.of<MessageModel>(context, listen: false).updateRemainingUsage();
    // Lấy danh sách prompts
    Provider.of<PromptListViewModel>(context, listen: false)
        .fetchAllPrompts()
        .then((_) {
      Provider.of<PromptListViewModel>(context, listen: false).allprompts;
    });

    // Load all Knowledgebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KnowledgeBaseProvider>(context, listen: false)
          .fetchAllKnowledgeBases(isLoadMore: false);
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      await Provider.of<AuthViewModel>(context, listen: false).fetchUserInfo();
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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
        MaterialPageRoute(builder: (context) => EmailComposer()),
      );
    } else if (index == 4) {
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
    if (_imagePaths == null && _controller.text.isEmpty) return;

    try {
      final aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == selectedAIItem);

      await Provider.of<MessageModel>(context, listen: false).sendMessage(
        _controller.text.isEmpty ? '' : _controller.text,
        aiItem,
        imagePaths: _imagePaths ?? null,
      );

      _controller.clear();

      // if (_imagePaths != null) {
      //   setState(() {
      //     _imagePaths = null;
      //   });
      // }
    } catch (e) {
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
    setState(() {
      selectedAIItem = newValue;
      AIItem aiItem =
          _listAIItem.firstWhere((aiItem) => aiItem.name == newValue);

      // Cập nhật selectedAIItem trong AIChatList
      Provider.of<AIChatList>(context, listen: false).setSelectedAIItem(aiItem);

      // Di chuyển item được chọn lên đầu danh sách
      _listAIItem.removeWhere((aiItem) => aiItem.name == newValue);
      _listAIItem.insert(0, aiItem);
    });
  }

  Widget _buildMessage(Message message) {
    bool isUser = message.role == 'user';
    bool isError = message.isErrored ?? false;

    Future<void> _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở link: $url')),
        );
      }
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isError
              ? Colors.red[100]
              : (isUser ? Colors.blue[100] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Consumer<MessageModel>(builder: (context, messageModel, child) {
          // Hiển thị loading nếu là tin nhắn model rỗng và đang trong trạng thái gửi
          if (!isUser && message.content.isEmpty && messageModel.isSending) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: isError ? Colors.red : Colors.black,
                  ),
                ),
              ],
            );
          }

          // Sử dụng Markdown widget cho tin nhắn model
          return Column(
            children: [
              isUser
                  ? Column(
                      children: [
                        if (message.imagePaths != null &&
                            message.imagePaths!.isNotEmpty) ...[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _imagePaths!.map((path) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        Text(
                          message.content,
                          style: TextStyle(
                              color: isError ? Colors.red : Colors.black),
                        ),
                      ],
                    )
                  : MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                            color: isError ? Colors.red : Colors.black),
                        a: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        listBullet: TextStyle(
                            color: isError ? Colors.red : Colors.black),
                      ),
                      selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          _launchURL(href);
                        }
                      },
                    )
            ],
          );
        }),
      ),
    );
  }

  Future<void> _openGallery() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _imagePaths = images.map((e) => e.path).toList();
        _isOpenDeviceWidget = false;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // Nếu chưa được cấp quyền, yêu cầu quyền
      await Permission.camera.request();
    }
  }

  Future<void> _openCamera() async {
    await _requestCameraPermission(); // Yêu cầu quyền trước khi mở camera
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePaths = [image.path];
        _isOpenDeviceWidget = false;
      });
    }
  }

  void _onTextChanged(String input) {
    if (input.isNotEmpty) {
      _showSlash = input.startsWith('/');
    } else {
      _showSlash = false; // Đặt lại _showSlash khi không có input
    }
  }

  void _takeScreenshot() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      // Lưu ảnh chụp màn hình vào một đường dẫn tạm thời
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/screenshot.png');
      await file.writeAsBytes(image);
      setState(() {
        _isOpenDeviceWidget = false;
        _imagePaths = [file.path];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final botModel = context.watch<BotViewModel>();
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        body: Consumer<MessageModel>(
          builder: (context, messageModel, child) {
            return Column(
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
                      !botModel.isChatWithMyBot
                          ? AIDropdown(
                              listAIItems: _listAIItem,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _updateSelectedAIItem(newValue);
                                }
                              },
                            )
                          : Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 238, 240, 243),
                                ),
                                height: 30,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    botModel.currentBot.assistantName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                      //const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://admin.dev.jarvis.cx/pricing/overview');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cannot open link!')),
                            );
                          }
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Upgrade',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                            Icon(
                              Icons.rocket,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                      ),
                      if (!botModel.isChatWithMyBot)
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 240, 243),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: Colors.blueAccent,
                            ),
                            messageModel.maxTokens == 99999 &&
                                    messageModel.maxTokens != null
                                ? const Text(
                                    "Unlimited",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blueAccent,
                                    ),
                                  )
                                : Text(
                                    '${messageModel.remainingUsage}',
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(119, 117, 117, 1.0)),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            Provider.of<MessageModel>(context, listen: false)
                                .clearMessage();
                            botModel.isChatWithMyBot = false;
                          }),
                    ],
                  ),
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (_isOpenDeviceWidget) {
                        _toggleDeviceVisibility();
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, bottom: 10, right: 10),
                            child: !botModel.isChatWithMyBot ? Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: messageModel.messages.length,
                                    itemBuilder: (context, index) {
                                      final message =
                                          messageModel.messages[index];
                                      return _buildMessage(message);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_showSlash)
                                  Consumer<PromptListViewModel>(
                                    builder: (context, promptList, child) {
                                      if (promptList.isLoading) {
                                        return const CircularProgressIndicator(); // Hoặc một widget khác để hiển thị khi đang tải
                                      } else if (promptList.hasError) {
                                        return Text(
                                            'Có lỗi xảy ra: ${promptList.error}'); // Hiển thị lỗi
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3 *
                                                2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255,
                                                    158,
                                                    198,
                                                    232), // Color of the border
                                                width:
                                                    1.0, // Width of the border
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0), // Border radius
                                            ),
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3),
                                            child: ListView.builder(
                                              itemCount: promptList
                                                  .allprompts.items.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(promptList
                                                      .allprompts
                                                      .items[index]
                                                      .title),
                                                  onTap: () {
                                                    _controller.text =
                                                        ""; // Chọn prompt
                                                    _showSlash = false;
                                                    PromptDetailsBottomSheet
                                                        .show(
                                                            context,
                                                            promptList
                                                                .allprompts
                                                                .items[index]);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        icon: const Icon(Icons.screenshot),
                                        onPressed: _takeScreenshot,
                                      ),
                                    ],
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color.fromARGB(
                                              255, 238, 240, 243),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 0.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (_imagePaths != null) ...[
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children:
                                                      _imagePaths!.map((path) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Image.file(
                                                              File(path),
                                                              width: 60,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: -15,
                                                            right: -15,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.close,
                                                                size: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        136,
                                                                        245,
                                                                        237,
                                                                        237),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _imagePaths = _imagePaths!
                                                                      .where((element) =>
                                                                          element !=
                                                                          path)
                                                                      .toList();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                            TextField(
                                              focusNode: _focusNode,
                                              controller: _controller,
                                              onChanged: _onTextChanged,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                hintText: (_imagePaths == null)
                                                    ? 'Nhập tin nhắn...'
                                                    : null,
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 14,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width:
                                                          1), // Viền bình thường
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Bo cong góc
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: _hasText || _imagePaths != null
                                          ? _sendMessage
                                          : null,
                                      style: IconButton.styleFrom(
                                        foregroundColor:
                                            _hasText || _imagePaths != null
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            )
                            : ChatWidget()
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedBottomItemIndex,
          onTap: _onTappedBottomItem,
        ),
      ),
    );
  }
}
