import 'package:chat_bloc_app/model/userModel.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class UserItem extends StatelessWidget {
  final Function()? onTap;
  final UserModel item;

  const UserItem({Key? key, required this.onTap, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)),
        child: Text(
          item.name?.substring(0, 1) ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        item.name ?? "",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: (item.isOnline == 'true') ? Colors.green : Colors.grey,
            size: 14,
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
