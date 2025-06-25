import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class common{
  static PreferredSizeWidget Appbar({
    required String title,
    required VoidCallback callback,
    List<Widget>? actions,
  }) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      // flexibleSpace: Container(
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/backgrounds/HeaderBG.png'),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      leading: IconButton(
        onPressed: callback,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      actions: actions,
    );
  }


  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date); // Requires intl package
  }

  // static const TextStyle Inter = TextStyle(
  //   fontWeight: FontWeight.w500,
  //   fontSize: 16,
  // );
}