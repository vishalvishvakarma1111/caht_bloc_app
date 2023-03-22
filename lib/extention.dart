import 'package:flutter/material.dart';

extension TxtStyle on TextStyle {
  TextStyle get normal => const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.black);

  TextStyle get bold => const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);

  TextStyle get semiBold => const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      );
}

extension InputDeco on InputDecoration {
  InputDecoration get deco => InputDecoration(
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 50),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
