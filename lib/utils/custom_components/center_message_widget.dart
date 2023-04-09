import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CenterMessageWidget extends StatelessWidget {
  final String centerTitle;
  final Widget? additionalWidget;
  const CenterMessageWidget(
      {super.key, required this.centerTitle, this.additionalWidget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (additionalWidget != null) additionalWidget!,
          Text(
            centerTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
