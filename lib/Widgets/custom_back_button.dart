import 'package:flutter/material.dart';
import '../models/model_warna.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomBackButton({
    Key? key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 18,
    this.padding = const EdgeInsets.only(
      left: 12,
      right: 12,
      top: 20,
      bottom: 20,
    ),
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          onPressed ??
          () {
            Navigator.pop(context);
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Warna().Ijo,
        shadowColor: Colors.transparent,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        minimumSize: Size(0, 0),
      ),
      child: Icon(
        Icons.arrow_back_ios_new,
        color: iconColor ?? Warna().Putih,
        size: iconSize,
      ),
    );
  }
}
