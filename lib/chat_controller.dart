import 'package:therapup/chat_message_type.dart';

import 'chat.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatController extends ChangeNotifier {
  /* Variables */
  List<Chat> chatList = Chat.generate();

  /* Controllers */
  late final ScrollController scrollController = ScrollController();
  late final TextEditingController textEditingController =
      TextEditingController();
  late final FocusNode focusNode = FocusNode();

  
  late OpenAI openAI = OpenAI.instance.build(
    token: "sk-svcacct-XPQTCUEaatKcUCXvevVaixPZ4j2pxhAzrMLJPl00GMTI7CZEfbWoiAHS2Lo2N_Qh2JRgT3BlbkFJJ4zsjtgBjETIEFUOPN6RwmWSkVOu6aFFgyeBiMnK8zhvunbhPzZ-4yFLy02sgsdtIOkA",  // project service account
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30)),
    enableLog: true
  );

  bool _isResponding = false;

  Future<ChatCTResponse?>? getResponse(String input) async {
    List<Map<String, dynamic>> messages = [
      Messages(
        role: Role.system,
        content: """You are a mental health chatbot designed to deliver CBT to the patient.
To accomplish this, follow these specific tasks:
    1. Get to know the user and what is specifically bothering them.
    2. Offer positive views to the problem at hand, encouraging positive ways of thinking.
    3. Identify the cause of the problem.
    4. Get the user to understand their thoughts, emotions, and or reactions.
    5. Create a plan for managing these responses.
Be there for the user at all times, and always show empathy.

The conversations you have with the users should be long and don't end in 1 prompt.
Refrain from trying to complete all of your tasks in 1 response and aim to have a long conversation instead."""
      ).toJson()
    ];  // update system message soon
    for (Chat chat in chatList) {
      messages.add(Messages(role: chat.type == ChatMessageType.sent ? Role.user : Role.assistant, content: chat.message).toJson());
    }

    final request = ChatCompleteText(
      messages: messages,
      maxToken: 4096,
      model: ChatModelFromValue(model: "ft:gpt-4o-mini-2024-07-18:personal:mh-bot:A9BiEwPE"),
    );

    ChatCTResponse? response;
    try {
      response = await openAI.onChatCompletion(request: request);
    } on Exception catch (err) {
      print('caught\n$err\nwhen awaiting openai response');
      return null;
    }

    return response;
  }

  // @override
  // void initState() {
  //   openAI = OpenAI.instance.build(
  //       // token: kToken,
  //       baseOption: HttpSetup(
  //           receiveTimeout: const Duration(seconds: 20),
  //           connectTimeout: const Duration(seconds: 20)),
  //       enableLog: true);
  //   super.initState();
  // }

  /* Intents */
  Future<void> onFieldSubmitted() async {
    if (!isTextFieldEnable) return;
    if (_isResponding) return;
    _isResponding = true;

    chatList.add(Chat.sent(message: textEditingController.text));

    // temp message
    chatList.add(Chat.received(message: "Typing..."));

    getResponse(textEditingController.text)?.then((ChatCTResponse? response) {
      if (response == null) {
        chatList.removeLast();
        chatList.add(Chat.received(message: "An error has occured."));
        notifyListeners(); 
      } else {
        print(response.choices[0].message?.content);
        chatList.removeLast();
        chatList.add(Chat.received(message: (response.choices[0].message?.content)!));
        notifyListeners();  // rebuild ui
      }

      _isResponding = false;
    });

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    textEditingController.text = '';
    notifyListeners();
  }

  void onFieldChanged(String term) {
    notifyListeners();
  }

  /* Getters */
  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;
}