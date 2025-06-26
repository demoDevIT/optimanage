import 'package:flutter/material.dart';

class RightToLeftRoute extends PageRouteBuilder {
  final Widget page;
  final Offset startOffset;
  final Duration duration;
   // startOffset: Offset(1.0, 0.0),  Slide from Right:
  // startOffset: Offset(0.0, 1.0),  Slide from Bottom:
 // startOffset: Offset(-1.0, 0.0), Slide from Left:
  RightToLeftRoute({
    required this.page,
    required this.startOffset, // Pass start offset for direction
    this.duration = const Duration(milliseconds: 300),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: startOffset, end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
