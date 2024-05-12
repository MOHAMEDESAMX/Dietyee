



import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/profile/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';


class GeminiAi extends StatefulWidget{
  const GeminiAi({super.key});


  @override
  State<StatefulWidget> createState() => _GeminiAi() ;

}


class _GeminiAi extends State<GeminiAi>{

  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages =[];

  
  ChatUser currentUser = ChatUser(id: "0",firstName: "User");
  ChatUser geminiUser = ChatUser(
    id:"1",
    firstName:"Gemini",
    profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png"
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030b18),
      appBar: AppBar(
        backgroundColor: const Color(0xff151724),
        centerTitle: true,

        title: const Text("AI Trainer",style: TextStyle(fontSize: 20,color: Colors.white),),
        leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Profile(),
                ));
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 30,
              )),
              ),
      body: _build(),
    );
  }

  Widget _build(){
    return DashChat(inputOptions: InputOptions(trailing: [
      IconButton(onPressed: _sendMediaMessage, icon: const Icon(Icons.image))
    ]),
      currentUser: currentUser, onSend: _sendMessage, messages: messages);

  }

  void _sendMessage(ChatMessage chatMessage){
    setState(() {
      messages =[chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty??false) {
        images=[File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question,images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage!=null && lastMessage.user == geminiUser) {
          lastMessage= messages.removeAt(0);
          String response =event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          lastMessage.text += response;
          setState(() {
            messages =[lastMessage!, ...messages];
          });
        }else{
          String response =event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(),text: response );
          setState(() {
            messages =[message, ...messages];
          });
        }
      });
    } catch (e) {
      log("$e");
    }

  }

  void _sendMediaMessage ()async {
    ImagePicker picker = ImagePicker();
    XFile? file =await picker.pickImage(source: ImageSource.gallery);
    if (file!= null) {
      ChatMessage chatMessage=ChatMessage(user: currentUser, createdAt: DateTime.now(),text: "Describe this picture",
      medias: [
        ChatMedia(url: file.path, fileName: "", type: MediaType.image)
      ] );
      _sendMessage(chatMessage);
    }
  }


}


