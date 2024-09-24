import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showDermaActionSheet(BuildContext context, List<String> options) async {
  return await showCupertinoModalPopup<String>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
     
      actions: options
          .map(
            (text) => CupertinoActionSheetAction(
              child: Text(text),
               isDestructiveAction: false,
              onPressed: () {
                Navigator.pop(context, text);
              },
            ),
          )
          .toList(),
      // cancelButton: CupertinoActionSheetAction(
      //   child: Text('Cancel'),
      //   isDefaultAction: true,
      //   onPressed: () {
      //     Navigator.pop(context, null); // Return null for cancel action
      //   },
      // ),
    ),
  );
}

