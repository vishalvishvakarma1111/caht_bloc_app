import 'package:chat_bloc_app/home/user_item.dart';
import 'package:chat_bloc_app/login/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat/chatview.dart';
import '../main.dart';
import '../model/userModel.dart';
import '../util/util.dart';
import 'bloc/home_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<HomeBloc>(context).add(SetOnlineStatusEvent(isOnline: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          Util.showToast(state.msg);
        } else if (state is HomeLoadedState && (state.logout ?? false)) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return const LoginView();
            },
          ), (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: getAppBar(state, context),
          body: state is HomeLoadedState ? list(state, context) : const SizedBox.shrink(),
        );
      },
    );
  }

  PreferredSizeWidget getAppBar(HomeState state, BuildContext context) {
    return AppBar(
      title: const Text('home'),
      actions: [
        Visibility(
            visible: state is HomeLoadedState && (state.logoutLoader ?? false),
            replacement: IconButton(
              onPressed: () {
                BlocProvider.of<HomeBloc>(context).add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ))
      ],
    );
  }

  Widget list(HomeLoadedState state, BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data?.docs.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var item = UserModel.fromMap(snapshot.data?.docs[index].data() ?? {});

                return UserItem(
                    onTap: () {
                      peerChatUser = item;
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return ChatView(peer: item);
                      })).then((value) {
                        peerChatUser = null;
                      });
                    },
                    item: item);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "No User found",
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
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<HomeBloc>(context).add(SetOnlineStatusEvent(isOnline: true));
    } else {
      BlocProvider.of<HomeBloc>(context).add(SetOnlineStatusEvent(isOnline: false));
      BlocProvider.of<HomeBloc>(context).add(LastSeenEvent());
    }
  }

  @override
  void dispose() {
    BlocProvider.of<HomeBloc>(context).add(LastSeenEvent());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }
}
