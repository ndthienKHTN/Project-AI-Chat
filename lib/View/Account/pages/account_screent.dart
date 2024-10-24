import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreent extends StatelessWidget {
  const AccountScreent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple,
                    child: Text(
                      'Đ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đức Thịnh Bùi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ducthinh12tn137@gmail.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.freepik.com/512/330/330710.png', // URL ảnh từ mạng
                      width: 70, // chiều rộng ảnh
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons
                            .error); // Nếu tải ảnh không thành công, hiển thị icon lỗi
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Miễn phí',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Truy vấn 1/40',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Nâng cấp'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Account Section
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('ducthinh12tn137'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.red[100], // Màu nền nút đăng xuất
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text('Log out'),
                        onTap: () {
                          // Hàm đăng xuất
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Support Section
                    const Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          // Mở Settings
                        },
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.chat_bubble_outline),
                        title: Text('Cài đặt trò chuyện'),
                        onTap: () {
                          // Mở Jarvis Playground
                        },
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.brightness_2_outlined),
                        title: Text('Chế độ màu sắc'),
                        subtitle: Text('Theo Hệ thống'),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Ngôn ngữ'),
                        subtitle: Text('Tiếng Việt'),
                        onTap: () {
                          // Mở Jarvis Playground
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // About Section
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.privacy_tip),
                        title: Text('Privacy Policy'),
                        onTap: () {
                          // Mở Privacy Policy
                        },
                      ),
                    ),
                    const Card(
                      color: Colors.white, // Màu nền sáng
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Version'),
                        trailing: Text('3.1.0'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
