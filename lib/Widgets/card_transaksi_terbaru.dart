import 'package:flutter/material.dart';
import '../models/model_warna.dart';

class CardTransaksiTerbaru extends StatelessWidget {
  final String transactionId;
  final String customerName;
  final String date;
  final String amount;
  final String? cashLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? secondaryTextColor;
  final Color? cashLabelColor;
  final double? borderRadius;

  const CardTransaksiTerbaru({
    Key? key,
    required this.transactionId,
    required this.customerName,
    required this.date,
    required this.amount,
    this.cashLabel,
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.cashLabelColor,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: backgroundColor ?? Warna().bgIjo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionId,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: textColor ?? Warna().Ijo,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    customerName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: secondaryTextColor ?? Colors.grey,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: secondaryTextColor ?? Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: textColor ?? Warna().Ijo,
                  ),
                ),
                SizedBox(height: 2  ),
                
                if (cashLabel != null)
                  Card(
                    shadowColor: Colors.transparent,
                    color: cashLabelColor ?? Warna().Ijo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(
                        cashLabel!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: Warna().Putih,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
