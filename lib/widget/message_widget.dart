import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prim_derma_app/widget/style.dart';

Future<void> showMessageDialog(
    String title, String message, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

BuildContext? dialogContext;
Future<void> showLoadingWidget(BuildContext context) async {
  // Show the dialog with the loading widget
  // Declare a context for the dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog by tapping outside
    builder: (BuildContext context) {
      dialogContext = context; // Assign the dialog context
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          
          children: <Widget>[
            CircularProgressIndicator(), // Loading indicator
            SizedBox(height: 20),
            Text("Loading..."), // Optional loading message
          ],
        ),
      );
    },
  );
}

void endLoadingWidget() {
  try {
    if (dialogContext != null) {
      Navigator.of(dialogContext!).pop();
    }
  } catch (e) {}
}

Future<void> showPrimMessageDialog(BuildContext context, String title, String text) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            EdgeInsets.zero, // Remove default padding around the title
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: SECONDARY_TEAL),
          //color: Colors.red, // Set the background color to red
          padding: const EdgeInsets.all(24.0), // Add padding inside the title
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Set the text color to white
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          
        ],
      ),
    );
  }

  
Future<bool> showPrimConfirmationDialog(BuildContext context, String title, String text) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            EdgeInsets.zero, // Remove default padding around the title
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: SECONDARY_TEAL),
          //color: Colors.red, // Set the background color to red
          padding: const EdgeInsets.all(24.0), // Add padding inside the title
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Set the text color to white
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          
        ],
      ),
    );
  }