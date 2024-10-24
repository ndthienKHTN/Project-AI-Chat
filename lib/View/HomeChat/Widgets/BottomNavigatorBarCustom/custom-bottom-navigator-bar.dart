import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.light_mode_sharp),
          label: 'Prompt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subtitles_sharp),
          label: 'Bot AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Information',
        ),
      ],
      currentIndex: currentIndex,
      unselectedItemColor: Colors.grey[600],
      selectedItemColor: Colors.blue,
      onTap: onTap,
    );
  }
}