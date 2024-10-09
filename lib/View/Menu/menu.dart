import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Menu extends StatefulWidget{
  const Menu({Key? key}) : super(key:key);
  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu>{
  int _selectedIndex =-1;
  void _logout() async{
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/logoAI.jpg", height: 60,),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Welcome to my App",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color.fromRGBO(
                                    69, 37, 229, 1.0),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: Colors.grey,
                                )
                            ),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (){
                              _logout();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color.fromRGBO(
                                    69, 37, 229, 1.0),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: Colors.grey,
                                )
                            ),
                            child: const Text(
                              "Log Out",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            ),
            _buildWidgetItem(Icons.add, "New chat", 0),
            _buildWidgetItem(Icons.person, "Personalities", 1),
            _buildWidgetItem(Icons.save_alt, "Saved chat", 2),
            _buildWidgetItem(Icons.smart_button, "Prompt Management", 3),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Divider(
            //   height: 0.5,
            //   color: Color.fromRGBO(2, 13, 82, 1.0),
            // ),
            _buildWidgetItem(Icons.play_lesson, "Knowledge Management", 4),
            _buildWidgetItem(Icons.verified_sharp, "Pro Version", 5),
            _buildWidgetItem(Icons.settings, "Setting", 6),
            const Divider(
              height: 0.5,
              color: Color.fromRGBO(2, 13, 82, 1.0),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    'Tất cả cuộc trò chuyện',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.search,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildWidgetItem(IconData icon, String title, int index){
    return InkWell(
      onTap: (){
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        color: (index== (_selectedIndex )) ? Colors.blue : null,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          // child: Column(
          // children: [
          //   Icon(icon),
          //   Text(title),
          // ],
          // ),
        ),
      ),
    );
  }
}