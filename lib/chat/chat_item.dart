import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/chat_model.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class ChatItem extends StatelessWidget {
  final ChatMessage item;

  const ChatItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    return item.idFrom == myUid ? rightItem() : leftItem();
  }

  Widget leftItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            painter: Triangle(Colors.white),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 1)],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: item.type == '0'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.content,
                        style: const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      const SizedBox(width: 5, height: 20),
                      Text(
                        DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(item.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  )
                : buildImage(item.url),
          ),
        ),
      ],
    );
  }

  Widget rightItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 5),
            decoration:   BoxDecoration(
              color: item.type == '0'? Colors.blue: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: item.type == '0'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.content,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(width: 5, height: 20),
                      const Text(
                        "01: 20 pm",
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ],
                  )
                : buildImage(item.url),
          ),
        ),
        CustomPaint(painter: Triangle(item.type == '0'? Colors.blue: Colors.white)),
      ],
    );
  }

  Widget buildImage(String url) {
    return SizedBox(
      height: 200,
      width: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class Triangle extends CustomPainter {
  final Color backgroundColor;

  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
