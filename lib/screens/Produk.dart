import 'package:flutter/material.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/card_produk.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';
import 'package:simulasi_ukk/services/database_service.dart';
import 'package:simulasi_ukk/models/product_model.dart';

class Produk extends StatefulWidget {
  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final DatabaseService _databaseService = DatabaseService();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _databaseService.getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load products: $e')));
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

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
                onChanged: _filterProducts,
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
              // Loading indicator or product list
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return CardProduk(
                        image: product.imageUrl ?? 'assets/fish.png',
                        productName: product.name,
                        price: 'IDR. ${product.price}',
                        stock: product.stock ?? 0,
                        onEdit: () {
                          // Navigate to EditProduk page with product data
                          Navigator.pushNamed(
                            context,
                            '/EditProduk',
                            arguments: {
                              'id': product.id,
                              'name': product.name,
                              'price': 'IDR. ${product.price}',
                              'category': product.category,
                              'image': product.imageUrl,
                              'stock': product.stock,
                            },
                          );
                        },
                        onDelete: () {
                          // Handle delete action
                          _confirmDeleteProduct(context, product);
                        },
                      );
                    },
                  ),
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

  void _confirmDeleteProduct(BuildContext context, ProductModel product) {
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
                  text: ' ${product.name}',
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
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    await _databaseService.deleteProduct(product.id);
                    await _loadProducts(); // Refresh the product list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product deleted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete product: $e')),
                    );
                  }
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
}
