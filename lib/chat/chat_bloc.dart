import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/network/api.dart';
import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../model/userModel.dart';
import '../util/firebase_service.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  String groupChatId = '';
  UserModel peer = UserModel();
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      emit(ChatLoadedState());
    });

    on<ChatInitialEvent>((event, emit) async {
      peer = event.peer;
      if (currentUserId.hashCode <= event.peer.uid.hashCode) {
        groupChatId = '$currentUserId-${event.peer.uid}';
      } else {
        groupChatId = '${event.peer.uid}-$currentUserId';
      }

      /// update id to chat
      final result = await FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: currentUserId).get();
      var docId = result.docs.first.id;

      FirebaseFirestore.instance.collection('user').doc(docId).update({'chatting_with': '${peer.uid}'});

      emit(ChatLoadedState());
    });

    on<SendMessageEvent>(_sendMessage);
    on<UploadImageEvent>(_uploadImage);
  }

  Future<FutureOr<void>> _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': currentUserId,
          'idTo': '${peer.uid}',
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': event.msg,
          'type': '0'
        },
      );
    });

    String name = await MyFirebaseUtil.instance.getName() ?? '';
    var map = {
      "to": peer.token,
      "priority": "high",
      'data': {'uid': peer.uid, 'name': peer.name},
      "notification": {"title": "Message  From $name", "body": event.msg}
    };

    ApiClient.instance.postApi(map: map);
  }

  FutureOr<void> _uploadImage(UploadImageEvent event, Emitter<ChatState> emit) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      emit(ChatLoadedState(loader: true));

      var imageFile = File(pickedFile.path ?? '');
      final storage = FirebaseStorage.instance.ref().child("/chat/images");
      TaskSnapshot taskSnapshot = await storage.putFile(imageFile);
      String url = await taskSnapshot.ref.getDownloadURL();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': currentUserId,
            'idTo': '${peer.uid}',
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': '',
            'url': url,
            'type': '1'
          },
        );
      });

      String name = await MyFirebaseUtil.instance.getName() ?? '';
      var map = {
        "to": peer.token,
        "priority": "high",
        'data': {'uid': peer.uid, 'name': peer.name},
        "notification": {"title": "Message  From $name", "body": 'Sent an image'}
      };

      ApiClient.instance.postApi(map: map);
      emit(ChatLoadedState(loader: false));
    }
  }
}
