

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bubble/bubble.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getChatbotReply(String userReply) async {
    var name = "Sravya_kandula";
    var response = await get(Uri.parse(
        "http://api.brainshop.ai/get?bid=167679&key=j5Uv9eV0MzEGn2qk&uid=${name }&msg=${userReply }"));
    var data = jsonDecode(response.body);
    setState(() {
      messages.insert(0, {"data": 0, "message": data["cnt"]});
    });
  }

  final userReply = TextEditingController();
  List<Map> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chat Bot')),
      ),
      body: Container(
        color: Color.fromARGB(173, 232, 223, 201),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          String cur_msg = messages[index]["message"];
                          int person = messages[index]["data"];

                          return Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                            child: Bubble(
                              margin: const BubbleEdges.only(top: 10.0),
                              alignment: person == 1
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              color: person == 1
                                  ? Color.fromARGB(255, 89, 174, 243)
                                  : Color.fromARGB(199, 255, 255, 255),
                              nip: person == 1
                                  ? BubbleNip.rightTop
                                  : BubbleNip.leftTop,
                              child: person == 0
                                  ? RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Bot\n',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 75, 170, 247),
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                            text: cur_msg,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  : Text(
                                      cur_msg,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  // ignore: prefer_const_constructors
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      controller: userReply,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(199, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        hintText: "Message",
                        isDense: true,
                        contentPadding: EdgeInsets.all(10.0),
                        focusColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          if (userReply.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messages.insert(
                                  0, {"data": 1, "message": userReply.text});
                              getChatbotReply(userReply.text);
                              print(messages.toString());
                              userReply.clear();
                            });
                          }
                        },
                        icon: Icon(Icons.send),
                        color: Color.fromARGB(240, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}