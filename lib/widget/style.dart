import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

LinearGradient PrimPrimaryGradient() {
  return LinearGradient(
      colors: [Colors.deepPurple[100]!, Colors.deepPurple[50]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}

// LinearGradient PrimPrimaryGradient() {
//   return LinearGradient(
//       colors: [Colors.blue[50]!, Colors.blueGrey[400]!],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight);
// }

class PrimButton extends StatelessWidget {
  PrimButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.color,
    Color? fontColor,
  }) : fontColor = fontColor ?? Colors.white;

  final void Function()? onPressed;
  final String text;
  final Color color;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        primaryColor: color,
      ),
      child: CupertinoButton.filled(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 18,
            color: fontColor,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}


PreferredSizeWidget PrimAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        wordSpacing: 3,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    ),
    flexibleSpace: Container(
      // Apply gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          //colors: [Colors.blueGrey[800]!, Colors.blueGrey[600]!],
          colors: [Colors.deepPurpleAccent[200]!, Colors.deepPurpleAccent[100]!],

          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize:
          const Size.fromHeight(2.0), // Set the height of the bottom line
      child: Container(
        color: Colors.white,
        height: 2.0, // Height of the white line
        width: double.infinity,
      ),
    ),
  );
}

final Color PRIMARY_GREY = Colors.blueGrey[300]!;

final Color PRIMARY_PURPLE = Colors.deepPurpleAccent[200]!;

final Color HIGHLIGHT_TEXT_COLOR = Colors.deepPurple[400]!;
final Color SECONDARY_TEXT_COLOR = Colors.blueGrey[800]!;
final Color SECONDARY_TEAL = Color(0xff116682);
final Color SECONDARY_GREEN = Colors.green[300]!;
