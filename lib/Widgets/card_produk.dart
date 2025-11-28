import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';

class CardProduk extends StatelessWidget {
  final String productName;
  final String price;
  final int stock;
  final String image;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardProduk({
    Key? key,
    required this.productName,
    required this.image,
    required this.price,
    required this.stock,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Warna().Putih,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 18, top: 8, bottom: 8),
        child: Row(
          children: [
            Card(
              color: Warna().bgUtama,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _buildImage(),
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'CircularStd',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16,
                          color: Warna().Ijo,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'GeneralSans',
                        ),
                      ),
                      Card(
                        color: Warna().bgIjo,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Center(
                            child: Text(
                              'Stok: $stock',
                              style: TextStyle(
                                fontSize: 10,
                                color: Warna().Ijo,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'CircularStd',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: Warna().bgUtama,
              shadowColor: Colors.transparent,
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (String result) {
                if (result == 'edit') {
                  onEdit();
                } else if (result == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          color: Warna().Ijo,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CircularStd',
                        ),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 14,
                          color: Warna().Merah,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CircularStd',
                        ),
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

  Widget _buildImage() {
    // Check if the image is a network URL (starts with http)
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a default asset image if network image fails to load
          return Image.asset('assets/fish.png', width: 50, height: 50);
        },
      );
    } else {
      // Assume it's an asset image
      return Image.asset(image, width: 50, height: 50);
    }
  }
}
