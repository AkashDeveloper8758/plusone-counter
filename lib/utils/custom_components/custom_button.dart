import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isLoading;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () => onPressed(),
          child: isLoading ? CircularProgressIndicator() : Text(title)),
    );
  }
}

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Function? onClick;
  final Color? borderColor;
  final Color? backGroundColor;
  final Widget? marketWidget;
  const RoundedContainer(
      {super.key,
      required this.child,
      this.onClick,
      this.borderColor,
      this.marketWidget,
      this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick ?? {},
      child: Stack(
        children: [
          Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: borderColor ??
                          Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(100),
                  color: backGroundColor ??
                      Theme.of(context).scaffoldBackgroundColor),
              child: child),
          if (marketWidget != null) Positioned(right: 0, child: marketWidget!)
        ],
      ),
    );
  }
}
