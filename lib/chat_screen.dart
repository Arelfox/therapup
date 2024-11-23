import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chat.dart';
import 'chat_controller.dart';
import 'bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> chatList = [];
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,  // make sure keyboard resizes app
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text("Chat"),
      // ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<ChatController>().focusNode.unfocus();
                // FocusScope.of(context).unfocus();
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: Selector<ChatController, List<Chat>>(
                  selector: (context, controller) =>
                      controller.chatList.reversed.toList(),
                  builder: (context, chatList, child) {
                    return ListView.separated(
                      shrinkWrap: true,
                      reverse: true,
                      padding: const EdgeInsets.only(top: 12, bottom: 20) +
                          const EdgeInsets.symmetric(horizontal: 12),
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 12,
                      ),
                      controller:
                          context.read<ChatController>().scrollController,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return Bubble(chat: chatList[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const _BottomInputField(),
        ],
      )
    );
  }
}

class SubmitIntent extends Intent {}  // press shift + enter to submit message

class _BottomInputField extends StatelessWidget {
  const _BottomInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 82, 82, 82),
            ),
          ),
        ),
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.enter): SubmitIntent(),
          },
          child: Actions(
            actions: <Type, Action<SubmitIntent>>{
              SubmitIntent: CallbackAction<SubmitIntent>(
                onInvoke: (SubmitIntent intent) => context.read<ChatController>().onFieldSubmitted(),
              ),
            },
            child: Stack(
              children: [
                TextField(
                  focusNode: context.read<ChatController>().focusNode,
                  onChanged: context.read<ChatController>().onFieldChanged,
                  controller: context.read<ChatController>().textEditingController,
                  minLines: 1,
                  maxLines: 7,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      right: 42,
                      left: 16,
                      top: 18,
                    ),
                    hintText: 'tell me something',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                // custom suffix btn
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    tooltip: "Shift + Enter",
                    icon: const Icon(Icons.send),
                    onPressed: context.read<ChatController>().onFieldSubmitted,
                  ),
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}