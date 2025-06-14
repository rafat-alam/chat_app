import 'package:chat_app/calls/calls_page.dart';
import 'package:chat_app/chats/chats_page.dart';
import 'package:chat_app/data.dart';
import 'package:chat_app/settings/settings_page.dart';
import 'package:chat_app/status_icon.dart';
import 'package:chat_app/status/status_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentPage,
          children: [
            ChatsPage(user : users, chatHis: chatHis,),
            StatusPage(),
            CallsPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
      
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          unselectedFontSize: 15,
      
          currentIndex: currentPage,
      
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
      
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: StatusIcon(
                imagePath: 'assets/img/img1.jpg',
                isSeen: false, // Set true if status has been seen
              ),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}