import 'package:flutter/material.dart';
import '../models/model_warna.dart';

class CardSatu extends StatelessWidget {
  final IconData icon;
  final String text;
  final String count;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;

  const CardSatu({
    Key? key,
    required this.icon,
    required this.text,
    this.count = '0',
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Warna().Putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderWidth!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor ?? Warna().Ijo),
            SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'CircularStd',
              ),
            ),
            SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'CircularStd',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
