import 'package:flutter/material.dart';

import '../../controller/page_controller.dart';

class ChatScreenComponent extends StatefulWidget {
  const ChatScreenComponent({super.key});

  @override
  State<ChatScreenComponent> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenComponent> {
  late List<String> list; //list of all the messages
  late List<String> listUserMessage; //list of all the user messages
  late ScrollController scrollController; //to scroll the list
  late TextEditingController textEditingController; //to get the user message
  bool isLoading = false; //to show the SKY is typing
  bool isError = false; //to show the SKY is offline
  @override
  void initState() {
    list = [];
    listUserMessage = [];
    scrollController = ScrollController();
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void askAI(String userMessage) async {
    setState(() {
      // all user message to list and listUserMessage
      listUserMessage.add(userMessage);
      list.add(userMessage);
      isLoading = true; //show SKY is typing
      // scroll to the bottom
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 1000,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    // get the AI message
    final aiRes = await getAIMessage(listUserMessage);
    // if the AI is offline
    if (aiRes == null) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    } else {
      // add the AI message to the list
      setState(() {
        list.add(aiRes);
        isLoading = false;
        // scroll to the bottom
        scrollController.animateTo(
          scrollController.position.maxScrollExtent +
              1000, //1000 is just a big number so that it scrolls to the bottom
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // generate the message so that it can be added to the page
  String generateMessage(List<String> messages) {
    String message = '\n'; // Start with a new line
    for (int i = 0; i < messages.length; i++) {
      if (i % 2 == 0) {
        message += "You: ${messages[i]}\n";
      } else {
        message += "SKY: ${messages[i]}\n";
      }
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    // PADDDING
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      // COLUMN - SKY CHAT, LISTVIEW, TEXTFIELD
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          // ROW - SKY logo and SKY chat
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sky-logo.png',
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'SKY',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          // LISTVIEW
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (index % 2 == 0) {
                  //if the index is even then it is a user message
                  // Align - to align the message to the right
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 8,
                        bottom: 4,
                        left: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        list[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                }
                // Align - to align the message to the left
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      bottom: 4,
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      list[index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
            ),
          ),
          // SIZEBOX
          const SizedBox(height: 10),
          // IF - SKY IS TYPING
          if (isLoading)
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'SKY is typing.. :)',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          // IF - SKY IS OFFLINE
          if (isError)
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'SKY is offline :(',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          // TEXTFIELD
          TextField(
            controller: textEditingController,
            autocorrect: true,
            decoration: InputDecoration(
              suffix: IconButton(
                onPressed: () {
                  if (isLoading) return; //if SKY is typing then return
                  if (isError) return; //if SKY is offline then return

                  // if the textfield is empty then return
                  if (textEditingController.text.isEmpty) {
                    return;
                  }
                  askAI(textEditingController.text); //ask AI
                  textEditingController.clear();
                },
                icon: const Icon(Icons.send),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Ask SKY',
              labelStyle: const TextStyle(fontSize: 15),
              constraints: const BoxConstraints(maxHeight: 70),
            ),
            onSubmitted: (value) {
              if (isLoading) return; //if SKY is typing then return
              if (isError) return; //if SKY is offline then return
              if (value.isEmpty) {
                return; //if the textfield is empty then return
              }
              askAI(value); //ask AI
              textEditingController.clear(); //clear the textfield
            },
            cursorHeight: 30, //cursor height
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
