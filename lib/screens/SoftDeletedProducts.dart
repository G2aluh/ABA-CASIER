import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/providers/product_provider.dart';
import 'package:simulasi_ukk/utils/rupiah.dart';

class SoftDeletedProducts extends StatefulWidget {
  @override
  _SoftDeletedProductsState createState() => _SoftDeletedProductsState();
}

class _SoftDeletedProductsState extends State<SoftDeletedProducts> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: AppBar(
        title: Text(
          'Produk Terhapus',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'GeneralSans',
            color: Warna().Hitam,
          ),
        ),
        backgroundColor: Warna().Putih,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Warna().Hitam),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              hintText: 'Cari Produk Terhapus',
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
            ),
            SizedBox(height: 16),
            // Display products using StreamBuilder for real-time updates
            Expanded(
              child: StreamBuilder<List<ProductModel>>(
                stream: Provider.of<ProductProvider>(
                  context,
                  listen: false,
                ).getSoftDeletedProductStream(),
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
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // The stream will automatically reconnect
                            },
                            child: Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Warna().Abu,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada produk yang terhapus',
                            style: TextStyle(fontSize: 16, color: Warna().Abu),
                          ),
                        ],
                      ),
                    );
                  }

                  // Filter products based on search query
                  List<ProductModel> filteredProducts = snapshot.data!;

                  if (_searchQuery.isNotEmpty) {
                    filteredProducts = filteredProducts.where((product) {
                      return product.name.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Warna().Abu),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada produk yang sesuai dengan pencarian',
                            style: TextStyle(fontSize: 16, color: Warna().Abu),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        color: Warna().Putih,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Product image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Warna().bgUtama,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child:
                                    product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        product.imageUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.image,
                                                color: Warna().Abu,
                                                size: 30,
                                              );
                                            },
                                      )
                                    : Icon(
                                        Icons.image,
                                        color: Warna().Abu,
                                        size: 30,
                                      ),
                              ),
                              SizedBox(width: 12),
                              // Product info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'CircularStd',
                                        color: Warna().Hitam,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      RupiahFormatter.format(product.price),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'GeneralSans',
                                        color: Warna().Ijo,
                                      ),
                                    ),
                                    if (product.deletedAt != null)
                                      Text(
                                        'Dihapus: ${product.deletedAt}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Action buttons
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.restore,
                                      color: Warna().Ijo,
                                    ),
                                    onPressed: () {
                                      _confirmRestoreProduct(
                                        context,
                                        product.id!,
                                        product.name,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Warna().Merah,
                                    ),
                                    onPressed: () {
                                      _confirmPermanentDeleteProduct(
                                        context,
                                        product.id!,
                                        product.name,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restoreProduct(int productId, String productName) async {
    try {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      await productProvider.restoreProduct(productId);

      // Show quick alert
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.showQuickAlert(
        context,
        'Produk "$productName" berhasil dipulihkan',
      );

      // No need to reload manually since we're using StreamBuilder
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memulihkan produk: $e'),
          backgroundColor: Warna().Merah,
        ),
      );
    }
  }

  Future<void> _permanentlyDeleteProduct(
    int productId,
    String productName,
  ) async {
    try {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      await productProvider.permanentlyDeleteProduct(productId);

      // Show quick alert
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.showQuickAlert(
        context,
        'Produk "$productName" berhasil dihapus permanen',
      );

      // No need to reload manually since we're using StreamBuilder
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus produk permanen: $e'),
          backgroundColor: Warna().Merah,
        ),
      );
    }
  }

  void _confirmRestoreProduct(
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
                'Pulihkan Produk',
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
              text: 'Apakah Anda yakin ingin memulihkan',
              children: [
                TextSpan(
                  text: ' $productName',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Ijo,
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
                  backgroundColor: MaterialStateProperty.all(Warna().MerahGelap),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Batal',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Putih,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Warna().Ijo),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _restoreProduct(productId, productName);
                },
                child: Text(
                  'Pulihkan',
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

  void _confirmPermanentDeleteProduct(
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
                'Hapus Permanen',
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
              text: 'Apakah Anda yakin ingin menghapus permanen',
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
                  text: '?\n\nTindakan ini tidak dapat dibatalkan.',
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
                  backgroundColor: MaterialStateProperty.all(Warna().Ijo),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Batal',
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Putih,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 8),
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
                  await _permanentlyDeleteProduct(productId, productName);
                },
                child: Text(
                  'Hapus Permanen',
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
