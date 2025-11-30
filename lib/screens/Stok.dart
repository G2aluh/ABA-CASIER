import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';
import 'package:simulasi_ukk/Widgets/card_produk_stok.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/providers/product_provider.dart';
import 'package:simulasi_ukk/providers/stock_provider.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/models/stok_model.dart';
import 'package:simulasi_ukk/models/stok_mutasi_model.dart';

class Stok extends StatefulWidget {
  @override
  _StokState createState() => _StokState();
}

class _StokState extends State<Stok> with SingleTickerProviderStateMixin {
  int _selectedFilter = 0; // 0 for Gudang, 1 for Riwayat
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() async {
    try {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final stockProvider = Provider.of<StockProvider>(context, listen: false);

      // Load products and stock data
      await productProvider.getProducts();
      await stockProvider.getStocks();
      await stockProvider.getStockMutations(limit: 10);
    } catch (e, stackTrace) {
      _logError('Failed to load initial data', e, stackTrace);
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data stok: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper method to log errors with detailed information
  _logError(String context, Object error, StackTrace stackTrace) {
    print('=== STOCK PAGE ERROR ===');
    print('Context: $context');
    print('Error: $error');
    print('Stack Trace: $stackTrace');
    print('Timestamp: ${DateTime.now()}');
    print('========================');
  }

  // Helper method to determine stock status
  _getStockStatus(int stockCount) {
    try {
      if (stockCount <= 0) {
        return {
          'status': 'Habis',
          'color': Warna().Merah,
          'bgColor': Warna().bgMerah,
        };
      } else if (stockCount <= 5) {
        return {
          'status': 'Menipis',
          'color': Warna().Oren,
          'bgColor': Warna().bgOren,
        };
      } else {
        return {
          'status': 'Aman',
          'color': Warna().Ijo,
          'bgColor': Warna().bgIjo,
        };
      }
    } catch (e, stackTrace) {
      _logError(
        'Error determining stock status for count: $stockCount',
        e,
        stackTrace,
      );
      // Default fallback
      return {
        'status': 'Unknown',
        'color': Warna().Abu,
        'bgColor': Warna().bgUtama,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Stok',
        onPersonTap: () {
          Navigator.pushNamed(context, '/ManajemenPelanggan');
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                children: [
                  // Tombol Filter Gudang
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: _selectedFilter == 0
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 0;
                      });
                    },
                    child: Text(
                      'Gudang',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedFilter == 0
                            ? Warna().Putih
                            : Warna().Ijo,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Tombol Filter Riwayat
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: _selectedFilter == 1
                          ? Warna().Ijo
                          : Warna().bgIjo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 1;
                      });
                    },
                    child: Text(
                      'Riwayat',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedFilter == 1
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

              // Show content based on selected filter
              if (_selectedFilter == 0)
                // Gudang content (real data)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomSearchBar(
                        hintText: 'Cari Produk',
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query.toLowerCase();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    // Stats cards will be updated dynamically
                    _buildStatsCards(context),
                    SizedBox(height: 8),
                    _buildProductStockList(context),
                    SizedBox(height: 12),
                  ],
                ),

              if (_selectedFilter == 1)
                // Riwayat content (stock mutation history)
                _buildStockMutationHistory(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 4, // Index for Stok
        onTap: (index) {
          _handleNavigation(context, index);
        },
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        try {
          if (stockProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Calculate stats
          int totalProducts = 0;
          int lowStockCount = 0;
          int outOfStockCount = 0;

          // We'll calculate these values based on actual stock data
          for (var stock in stockProvider.stocks) {
            totalProducts++;
            if (stock.jumlahBarang <= 0) {
              outOfStockCount++;
            } else if (stock.jumlahBarang <= 5) {
              lowStockCount++;
            }
          }

          return Center(
            child: Row(
              children: [
                //Card stok alert
                Expanded(
                  child: Card(
                    color: Warna().Putih,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: const Color.fromARGB(175, 218, 218, 218),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 19,
                        right: 19,
                        top: 28,
                        bottom: 28,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Total Produk',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'CircularStd',
                              ),
                            ),
                            Text(
                              '$totalProducts',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'GeneralSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Warna().Putih,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: const Color.fromARGB(175, 218, 218, 218),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 19,
                        right: 19,
                        top: 28,
                        bottom: 28,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Stok Rendah',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'CircularStd',
                              ),
                            ),
                            Text(
                              '$lowStockCount',
                              style: TextStyle(
                                fontSize: 24,
                                color: Warna().Oren,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'GeneralSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Warna().Putih,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: const Color.fromARGB(175, 218, 218, 218),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 19,
                        right: 19,
                        top: 28,
                        bottom: 28,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Stok Habis',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'CircularStd',
                              ),
                            ),
                            Text(
                              '$outOfStockCount',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'GeneralSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Card stok alert
              ],
            ),
          );
        } catch (e, stackTrace) {
          _logError('Error building stats cards', e, stackTrace);
          return Center(
            child: Text(
              'Error memuat statistik: ${e.toString()}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget _buildProductStockList(BuildContext context) {
    return Consumer2<ProductProvider, StockProvider>(
      builder: (context, productProvider, stockProvider, child) {
        try {
          if (productProvider.isLoading || stockProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (productProvider.errorMessage != null ||
              stockProvider.errorMessage != null) {
            final errorMessage =
                productProvider.errorMessage ??
                stockProvider.errorMessage ??
                'Error loading data';
            _logError('Provider error', errorMessage, StackTrace.current);
            return Center(
              child: Column(
                children: [
                  Text(
                    'Error: $errorMessage',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading data
                      _loadData();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // Filter products based on search query
          List<ProductModel> filteredProducts = productProvider.products;
          if (_searchQuery.isNotEmpty) {
            filteredProducts = filteredProducts.where((product) {
              return product.name.toLowerCase().contains(_searchQuery);
            }).toList();
          }

          // Group products with their stock information
          List<Map<String, dynamic>> productStockData = [];

          for (var product in filteredProducts) {
            try {
              // Find corresponding stock record from real-time data
              StokModel? stock = product.id != null
                  ? stockProvider.getCurrentStockByProductId(product.id!) ??
                        StokModel(produkId: product.id!, jumlahBarang: 0)
                  : StokModel(produkId: 0, jumlahBarang: 0);

              final stockInfo = _getStockStatus(stock.jumlahBarang);

              productStockData.add({
                'product': product,
                'stock': stock,
                'status': stockInfo['status'],
                'statusColor': stockInfo['color'],
                'stockCardColor': stockInfo['bgColor'],
                'stockCount': stock.jumlahBarang.toString(),
              });
            } catch (e, stackTrace) {
              _logError(
                'Error processing product: ${product.name}',
                e,
                stackTrace,
              );
              // Continue with other products
            }
          }

          if (productStockData.isEmpty) {
            return Center(child: Text('Tidak ada produk'));
          }

          // Build rows of product cards (2 per row)
          List<Widget> rows = [];
          for (int i = 0; i < productStockData.length; i += 2) {
            try {
              List<Widget> cards = [];

              // Add first card
              cards.add(
                Expanded(
                  child: CardProdukStok(
                    productName: productStockData[i]['product'].name,
                    status: productStockData[i]['status'],
                    stockCount: productStockData[i]['stockCount'],
                    image:
                        productStockData[i]['product'].imageUrl ??
                        'assets/fish.png',
                    statusColor: productStockData[i]['statusColor'],
                    stockCardColor: productStockData[i]['stockCardColor'],
                    onEdit: () {
                      try {
                        Navigator.pushNamed(
                          context,
                          '/EditStok',
                          arguments: productStockData[i],
                        );
                      } catch (e, stackTrace) {
                        _logError(
                          'Error navigating to EditStok for product: ${productStockData[i]["product"].name}',
                          e,
                          stackTrace,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal membuka halaman edit stok'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );

              // Add second card if exists
              if (i + 1 < productStockData.length) {
                cards.add(
                  Expanded(
                    child: CardProdukStok(
                      productName: productStockData[i + 1]['product'].name,
                      status: productStockData[i + 1]['status'],
                      stockCount: productStockData[i + 1]['stockCount'],
                      image:
                          productStockData[i + 1]['product'].imageUrl ??
                          'assets/fish.png',
                      statusColor: productStockData[i + 1]['statusColor'],
                      stockCardColor: productStockData[i + 1]['stockCardColor'],
                      onEdit: () {
                        try {
                          Navigator.pushNamed(
                            context,
                            '/EditStok',
                            arguments: productStockData[i + 1],
                          );
                        } catch (e, stackTrace) {
                          _logError(
                            'Error navigating to EditStok for product: ${productStockData[i + 1]["product"].name}',
                            e,
                            stackTrace,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal membuka halaman edit stok'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }

              rows.add(Row(children: cards));

              rows.add(SizedBox(height: 8));
            } catch (e, stackTrace) {
              _logError(
                'Error building product row at index: $i',
                e,
                stackTrace,
              );
              // Continue with other rows
            }
          }

          return Column(children: rows);
        } catch (e, stackTrace) {
          _logError('Error building product stock list', e, stackTrace);
          return Center(
            child: Column(
              children: [
                Text(
                  'Error memuat daftar produk: ${e.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading data
                    _loadData();
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildStockMutationHistory(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        try {
          if (stockProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (stockProvider.errorMessage != null) {
            _logError(
              'Stock mutation error',
              stockProvider.errorMessage!,
              StackTrace.current,
            );
            return Center(
              child: Column(
                children: [
                  Text(
                    'Error: ${stockProvider.errorMessage!}',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading data
                      _loadData();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          List<StokMutasiModel> mutations = stockProvider.stockMutations;

          // Limit to 10 most recent mutations
          if (mutations.length > 10) {
            mutations = mutations.take(10).toList();
          }

          if (mutations.isEmpty) {
            return Center(child: Text('Tidak ada riwayat perubahan stok'));
          }

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Card title perubahan stok
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Warna().Putih,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Perubahan Stok',
                                    style: TextStyle(
                                      fontFamily: "CircularStd",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '10 Perubahan Terbaru',
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Build list of mutations
                ...mutations.map((mutation) {
                  try {
                    return _buildMutationCard(mutation);
                  } catch (e, stackTrace) {
                    _logError(
                      'Error building mutation card for mutation ID: ${mutation.id}',
                      e,
                      stackTrace,
                    );
                    return Container(); // Return empty container on error
                  }
                }).toList(),
              ],
            ),
          );
        } catch (e, stackTrace) {
          _logError('Error building stock mutation history', e, stackTrace);
          return Center(
            child: Column(
              children: [
                Text(
                  'Error memuat riwayat stok: ${e.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading data
                    _loadData();
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMutationCard(StokMutasiModel mutation) {
    try {
      // Determine if it's an addition or subtraction
      bool isAddition = mutation.qty > 0;
      String displayQty = isAddition
          ? '+${mutation.qty}'
          : mutation.qty.toString();
      Color qtyColor = isAddition ? Warna().Ijo : Warna().Merah;

      return Row(
        children: [
          Expanded(
            child: Card(
              elevation: 0,
              color: Warna().Putih,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(
                          displayQty,
                          style: TextStyle(
                            color: qtyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'CircularStd',
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mutation.keterangan ?? 'Perubahan Stok',
                          style: TextStyle(
                            fontFamily: "CircularStd",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          mutation.createdAt != null
                              ? '${mutation.createdAt!.day}/${mutation.createdAt!.month}/${mutation.createdAt!.year}, ${mutation.createdAt!.hour}:${mutation.createdAt!.minute.toString().padLeft(2, '0')}'
                              : 'Tanggal tidak tersedia',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } catch (e, stackTrace) {
      _logError('Error building mutation card', e, stackTrace);
      return Container(
        child: Text(
          'Error menampilkan riwayat: ${e.toString()}',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    try {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/Dashboard');
          break;
        case 1:
          Navigator.pushNamed(context, '/Penjualan');
          break;
        case 2:
          Navigator.pushNamed(context, '/Produk');
          break;
        case 3:
          Navigator.pushNamed(context, '/Laporan');
          break;
        case 4:
          // Already on Stok screen
          break;
        default:
          _logError(
            'Unknown navigation index: $index',
            'Invalid navigation index',
            StackTrace.current,
          );
      }
    } catch (e, stackTrace) {
      _logError('Error handling navigation for index: $index', e, stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal navigasi ke halaman yang diminta')),
      );
    }
  }
}
