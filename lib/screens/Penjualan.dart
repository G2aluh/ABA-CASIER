import 'package:flutter/material.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';

class Penjualan extends StatefulWidget {
  @override
  _PenjualanState createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> {
  List<int> _selectedProductIndices = []; // Track selected product indices
  List<Map<String, dynamic>> _products = [
    {
      'name': 'Fish',
      'price': 'Rp200.000',
      'image': 'assets/fish.png',
      'stock': 2,
    },
    {
      'name': 'Telegram',
      'price': 'Rp150.000',
      'image': 'assets/legram.png',
      'stock': 5,
    },
  ];

  void _toggleProductSelection(int index) {
    setState(() {
      if (_selectedProductIndices.contains(index)) {
        // If already selected, remove from selection
        _selectedProductIndices.remove(index);
      } else {
        // Add to selection
        _selectedProductIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Penjualan',
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
              Row(
                children: [
                  //Card Produk siap jual
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleProductSelection(0),
                      child: Card(
                        color: Warna().Putih,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: _selectedProductIndices.contains(0)
                              ? BorderSide(color: Warna().Ijo, width: 2.0)
                              : BorderSide.none,
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
                                        child: Image.asset('assets/fish.png')
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      'Fish',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'CircularStd',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      'Rp200.000',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Warna().Ijo,
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
                                color: Warna().bgIjo,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    _products[0]['stock'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Warna().Ijo,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleProductSelection(1),
                      child: Card(
                        color: Warna().Putih,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: _selectedProductIndices.contains(1)
                              ? BorderSide(color: Warna().Ijo, width: 2.0)
                              : BorderSide.none,
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
                                        child: Image.asset('assets/legram.png')
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      'Telegram',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'CircularStd',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      'Rp150.000',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Warna().Ijo,
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
                                color: Warna().bgIjo,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    _products[1]['stock'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Warna().Ijo,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Card Produk siap jual
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 1, // Index for Penjualan
        onTap: (index) {
          _handleNavigation(context, index);
        },
      ),
      // Floating Action Button for cart
      floatingActionButton: _selectedProductIndices.isNotEmpty
          ? FloatingActionButton(
              highlightElevation: 0,
              elevation: 0,
              onPressed: () {
                // Navigate to cart with selected products
                List<Map<String, dynamic>> selectedProducts =
                    _selectedProductIndices
                        .map((index) => _products[index])
                        .toList();
                Navigator.pushNamed(
                  context,
                  '/Keranjang',
                  arguments: selectedProducts,
                );
              },
              backgroundColor: Warna().Ijo,
              child: Icon(Icons.shopping_cart, color: Warna().Putih),
            )
          : null,
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/Dashboard');
        break;
      case 1:
        // Already on Penjualan screen
        break;
      case 2:
        Navigator.pushNamed(context, '/Produk');
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
