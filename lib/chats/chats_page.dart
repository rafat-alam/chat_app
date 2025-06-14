import 'package:chat_app/chats/user_chat/user_chat_page.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final List<Map<dynamic, dynamic>> user;
  final Map<String, Map<String, Map<String, Object>>> chatHis;
  const ChatsPage({
    super.key,
    required this.user,
    required this.chatHis,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  final border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(225, 225, 225, 1),
    ),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(50),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chats',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(
                        Icons.search
                      ),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return UserChatPage();
                        }
                      )
                    );
                  },
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        debugPrint("Hiii");
                      },
                      child: CircleAvatar(
                        radius: 30,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.user[index]['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          (((widget.chatHis[widget.user[index]['user']]?['rafat1']?['msg'] as List<dynamic>?)?[0] as Map<String, dynamic>)['time'] as String).substring(11, 16),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ((widget.chatHis[widget.user[index]['user']]?['rafat1']?['msg'] as List<dynamic>?)?[0] as Map<String, dynamic>)['text'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        if(widget.chatHis[widget.user[index]['user']]?['rafat1']?['unread'] as int > 0 && widget.chatHis[widget.user[index]['user']]?['rafat1']?['unread'] as int < 100)
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 20,
                            //width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue, // Bubble color
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: Text(
                                (widget.chatHis[widget.user[index]['user']]?['rafat1']?['unread']).toString(),
                                style: TextStyle(
                                  color: Colors.white, 
                                ),
                              ),
                            ),
                          )
                        else if(widget.chatHis[widget.user[index]['user']]?['rafat1']?['unread'] as int > 100)
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 20,
                            //width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue, // Bubble color
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: Text(
                                '99+',
                                style: TextStyle(
                                  color: Colors.white, 
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}