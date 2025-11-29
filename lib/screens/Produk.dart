import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/card_produk.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';
import 'package:simulasi_ukk/providers/product_provider.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/screens/EditProduk.dart';
import 'package:simulasi_ukk/utils/rupiah.dart';

class Produk extends StatefulWidget {
  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  String? _selectedCategory;
  String _searchQuery = '';
  final List<String> _categories = ['Game', 'Musik', 'Produktif'];

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
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 8),
              // Filter Button
              Row(
                children: [
                  //ALL
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: _selectedCategory == null
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedCategory == null
                            ? Warna().Putih
                            : Warna().Ijo,
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
                      backgroundColor: _selectedCategory == 'Game'
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Game';
                      });
                    },
                    child: Text(
                      'Game',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedCategory == 'Game'
                            ? Warna().Putih
                            : Warna().Ijo,
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
                      backgroundColor: _selectedCategory == 'Musik'
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Musik';
                      });
                    },
                    child: Text(
                      'Musik',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedCategory == 'Musik'
                            ? Warna().Putih
                            : Warna().Ijo,
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
                      backgroundColor: _selectedCategory == 'Produktif'
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Produktif';
                      });
                    },
                    child: Text(
                      'Produktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedCategory == 'Produktif'
                            ? Warna().Putih
                            : Warna().Ijo,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/SoftDeletedProducts');
                    },
                    child: Card(
                      color: Warna().MerahGelap,
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
                              Icon(
                                Icons.delete,
                                color: Warna().Putih,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Produk Terhapus',
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
              // Display products using StreamBuilder for real-time updates
              Expanded(
                child: StreamBuilder<List<ProductModel>>(
                  stream: Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  ).productsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${snapshot.error}'),
                            ElevatedButton(
                              onPressed: () {
                                // The stream will automatically reconnect
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Tidak ada produk'));
                    }

                    // Filter products based on search query and selected category
                    List<ProductModel> filteredProducts = snapshot.data!;

                    // Apply search filter
                    if (_searchQuery.isNotEmpty) {
                      filteredProducts = filteredProducts.where((product) {
                        return product.name.toLowerCase().contains(
                          _searchQuery,
                        );
                      }).toList();
                    }

                    // Apply category filter
                    if (_selectedCategory != null) {
                      filteredProducts = filteredProducts.where((product) {
                        if (product.category == null) return false;
                        return product.category == _selectedCategory;
                      }).toList();
                    }

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Text('Tidak ada produk yang sesuai'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return CardProduk(
                          image: product.imageUrl ?? 'assets/fish.png',
                          productName: product.name,
                          price: RupiahFormatter.format(product.price),
                          stock:
                              0, // We'll need to get stock information from a separate table
                          onEdit: () {
                            // Navigate to EditProduk page with product data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProduk(product: product),
                              ),
                            );
                          },
                          onDelete: () {
                            _confirmDeleteProduct(
                              context,
                              product.id!,
                              product.name,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
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

  void _confirmDeleteProduct(
    BuildContext context,
    int productId,
    String productName,
  ) {
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
                  text: ' $productName',
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
                    final productProvider = Provider.of<ProductProvider>(
                      context,
                      listen: false,
                    );
                    await productProvider.deleteProduct(productId);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Produk berhasil dihapus')),
                    );
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menghapus produk: $e')),
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
