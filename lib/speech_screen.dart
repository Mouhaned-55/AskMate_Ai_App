import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_recorder/api_service.dart';
import 'package:voice_recorder/chat_model.dart';
import 'package:voice_recorder/colors.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  bool isListening = false;
  String text = "Hold the button and ask anything you want";
  SpeechToText speechToText = SpeechToText();
  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 1600),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
            messages.add(ChatMessage(text: text, type: ChatMessageType.user));
            var msg = await ApiService.sendMessage(text);

            setState(() {
              messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
            });
          },
        ),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "AskMate",
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: chatGptColor, borderRadius: BorderRadius.circular(12)),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];

                    return chatBubble(chatText: chat.text, type: chat.type);
                  }),
            )),
            const Text(
              "Developed by Mouhaned Akermi",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chatText, required ChatMessageType? type}) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                child: Text(
                  "$chatText",
                  style: const TextStyle(
                      color: chatGptColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                )),
          ),
        ],
      ),
    );
  }
}
