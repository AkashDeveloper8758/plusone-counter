import 'package:flutter/material.dart';

class ConformationDialogWidget extends StatelessWidget {
  final String title;
  const ConformationDialogWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes')),
        ],
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
