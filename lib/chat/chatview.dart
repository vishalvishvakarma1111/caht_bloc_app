import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/homeview.dart';
import '../model/chat_model.dart';
import '../model/userModel.dart';
import '../shopping/home_shopping/home_shopping_view.dart';
import 'chat_bloc.dart';
import 'chat_item.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class ChatView extends StatelessWidget {
  final UserModel peer;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  ChatView({Key? key, required this.peer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(ChatInitialEvent(peer: peer)),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffE2EAFB),
            appBar: AppBar(
              leading: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const BackButtonIcon(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                      ),
                      child: Text(
                        peer.name?.substring(0, 1) ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(peer.name ?? ''),
              actions: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      var item = UserModel.fromMap(snapshot.data?.docs.first.data() ?? {});
                      return Visibility(
                        visible: item.isOnline == 'true',
                        child: const Icon(
                          Icons.circle,
                          size: 14,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                lastSeen(),
              ],
            ),
            body: state is ChatLoadedState ? chatList(state, context) : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget textField(ChatState state, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: messageController,
        decoration: InputDecoration(
          hintText: 'Start write here',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  if (messageController.text.isNotEmpty) {
                    BlocProvider.of<ChatBloc>(context).add(
                      SendMessageEvent(
                        msg: messageController.text.trim(),
                      ),
                    );
                    messageController.clear();

                    final bottomOffset = scrollController.position.maxScrollExtent;
                    scrollController.animateTo(
                      bottomOffset,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<ChatBloc>(context).add(UploadImageEvent());
                },
                icon: const Icon(
                  Icons.attachment_sharp,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          filled: true,
          fillColor: Colors.white,
          constraints: const BoxConstraints(minHeight: 45, maxHeight: 50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget chatList(ChatLoadedState state, BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String groupChatId = '';
    if (currentUserId.hashCode <= peer.uid.hashCode) {
      groupChatId = '$currentUserId-${peer.uid}';
    } else {
      groupChatId = '${peer.uid}-$currentUserId';
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xffE2EAFB),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic>? data = snapshot.data?.docs[index].data();
                        var item = ChatMessage.fromMap(data ?? {});
                        return ChatItem(
                          item: item,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "No Chat found",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
        Visibility(
          visible: state.loader ?? false,
          replacement: const SizedBox.shrink(),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        textField(state, context),
       ],
    );
  }

  Widget lastSeen() {
    return Container(
      padding: const EdgeInsets.all(1.0),
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          var item = UserModel.fromMap(snapshot.data?.docs.first.data() ?? {});

          return item.isOnline == 'false' && item.lastSeen != null
              ? Text(
                  'Last seen${DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(item.lastSeen ?? '222222'),
                    ),
                  )}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
