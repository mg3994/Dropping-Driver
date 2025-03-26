import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
   final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color boxShadowColor;
  final double blurRadius;
  final Offset boxShadowOffset;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(1.0),
    this.borderRadius = 2.0,
    this.boxShadowColor = const Color(0x1A000000), // Colors.black.withOpacity(0.1)
    this.blurRadius = 5.0,
    this.boxShadowOffset = const Offset(0, 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor,
            blurRadius: blurRadius,
            offset: boxShadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}
