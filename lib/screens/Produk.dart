import 'package:flutter/material.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/card_produk.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';

class Produk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Produk',
        onPersonTap: () {
          // Handle person icon tap
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Container(
          child: Column(
            children: [
              CustomSearchBar(
                hintText: 'Cari Produk',
              ),
              SizedBox(height: 8),

              // Filter Button
              Row(
                children: [
                  //ALL
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().Ijo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Warna().Putih,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),

                  SizedBox(width: 8),
                  //Game
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Game',
                      style: TextStyle(
                        fontSize: 12,
                        color: Warna().Ijo,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  //Musik
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Musik',
                      style: TextStyle(
                        fontSize: 12,
                        color: Warna().Ijo,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  //Produktif
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Produktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: Warna().Ijo,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/TambahProduk');
                    },
                    child: Card(
                      color: Warna().Ijo,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 18,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Warna().Putih, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'Tambah Produk  ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Warna().Putih,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'CircularStd',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              //Card untuk produk yang sudah dibuat
              CardProduk(
                image: 'assets/fish.png',
                productName: 'Fish',
                price: 'IDR. 100.000',
                stock: 8,
                onEdit: () {
                  // Navigate to EditProduk page with product data
                  Navigator.pushNamed(
                    context,
                    '/EditProduk',
                    arguments: {
                      'name': 'Fish',
                      'price': 'IDR. 100.000',
                      'category': 'Game',
                      'image': 'assets/fish.png',
                      'stock': 8,
                    },
                  );
                },
                onDelete: () {
                  // Handle delete action
                  _confirmDeleteProduct(context);
                },
              ),
              SizedBox(height: 8),
              CardProduk(
                image: 'assets/notes.png',
                productName: 'Book Moon',
                price: 'IDR. 150.000',
                stock: 12,
                onEdit: () {
                  // Navigate to EditProduk page with product data
                  Navigator.pushNamed(
                    context,
                    '/EditProduk',
                    arguments: {
                      'name': 'Book Moon',
                      'price': 'IDR. 150.000',
                      'category': 'Musik',
                      'image': 'assets/notes.png',
                      'stock': 12,
                    },
                  );
                },
                onDelete: () {
                  _confirmDeleteProduct(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 2, // Index for Produk
        onTap: (index) {
          _handleNavigation(context, index);
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/Dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/Penjualan');
        break;
      case 2:
        // Already on Produk screen
        break;
      case 3:
        Navigator.pushNamed(context, '/Laporan');
        break;
      case 4:
        Navigator.pushNamed(context, '/Stok');
        break;
    }
  }
}


void _confirmDeleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: Warna().Putih,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hapus Produk',
                style: TextStyle(
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Warna().Hitam,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, color: Warna().Hitam),
              ),
            ],
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Apakah Anda yakin ingin menghapus',
              children: [
                TextSpan(
                  text: ' Produk(Nama Produk)',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().MerahGelap,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Hitam,
                  ),
                ),
              ],
              style: TextStyle(
                fontFamily: "CircularStd",
                fontWeight: FontWeight.w400,
                color: Warna().Hitam,
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Warna().MerahGelap,
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Hapus',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Putih,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }