import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTap;

  const NotificationView({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: SafeArea(
          bottom: false,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: kElevationToShadow[2],
            ),
            child: buildBody(),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: const Icon(
                Icons.chat_sharp,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            const Text(
              'Chat App',
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 6,
          ),
        ),
        Text(
          title,
        ),
        const Padding(padding: EdgeInsets.only(top: 6)),
        Text(
          subTitle,
          maxLines: 3,
        ),
      ],
    );
  }
}
