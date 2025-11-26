import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';

class CardProdukStok extends StatelessWidget {
  final String productName;
  final String status;
  final String stockCount;
  final String image;
  final Color statusColor;
  final Color stockCardColor;
  final VoidCallback onEdit;

  const CardProdukStok({
    Key? key,
    required this.productName,
    required this.status,
    required this.stockCount,
    required this.image,
    required this.statusColor,
    required this.stockCardColor,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Warna().Putih,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Warna().Abu, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 8,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Card Produk isi
                Card(
                  color: Warna().bgUtama,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Image.asset(image, width: 80, height: 80),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'CircularStd',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Stock indicator card at top-right corner
          Positioned(
            top: 16,
            right: 18,
            child: Card(
              color: stockCardColor,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  stockCount,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Edit button at bottom-right corner
          Positioned(
            bottom: 18,
            right: 10,
            child: GestureDetector(
              onTap: onEdit,
              child: Card(
                color: Warna().bgUtama,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.edit_outlined, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
