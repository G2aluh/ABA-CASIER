import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/Widgets/custom_back_button.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/providers/stock_provider.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/models/stok_model.dart';
import 'package:simulasi_ukk/models/stok_mutasi_model.dart';

class EditStok extends StatefulWidget {
  @override
  _EditStokState createState() => _EditStokState();
}

class _EditStokState extends State<EditStok> {
  // Controllers for form fields
  late TextEditingController _currentStockController;
  late TextEditingController _changeStockController;

  // Product data
  Map<String, dynamic>? _productStockData;
  ProductModel? _product;
  StokModel? _stock;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _currentStockController = TextEditingController();
    _changeStockController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the product data passed from the previous screen
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      setState(() {
        _productStockData = arguments;
        _product = _productStockData!['product'];
        _stock = _productStockData!['stock'];
        _currentStockController.text = _stock?.jumlahBarang.toString() ?? '0';
      });
    }
  }

  @override
  void dispose() {
    _currentStockController.dispose();
    _changeStockController.dispose();
    super.dispose();
  }

  // Helper method to log errors with detailed information
  _logError(String context, Object error, StackTrace stackTrace) {
    print('=== EDIT STOCK PAGE ERROR ===');
    print('Context: $context');
    print('Error: $error');
    print('Stack Trace: $stackTrace');
    print('Timestamp: ${DateTime.now()}');
    print('==============================');
  }

  // Method to update stock
  _updateStock() async {
    if (_product == null) {
      _logError(
        'Product is null',
        'Cannot update stock for null product',
        StackTrace.current,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Produk tidak ditemukan')));
      return;
    }

    final stockProvider = Provider.of<StockProvider>(context, listen: false);

    try {
      final newStockValueString = _changeStockController.text;
      if (newStockValueString.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Masukkan jumlah stok baru')));
        return;
      }

      final newStockValue = int.tryParse(newStockValueString);
      if (newStockValue == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Masukkan angka yang valid')));
        return;
      }

      // Calculate the difference between new and current stock
      final currentStock = _stock?.jumlahBarang ?? 0;
      final stockDifference = newStockValue - currentStock;

      // Add stock mutation record only (let database triggers handle stock update)
      final mutation = StokMutasiModel(
        produkId: _product!.id,
        qty: stockDifference,
        jenisMutasi: stockDifference > 0
            ? 'masuk'
            : (stockDifference < 0 ? 'keluar' : 'netral'),
        keterangan: 'Perubahan stok untuk ${_product!.name}',
        createdAt: DateTime.now(),
      );

      await stockProvider.addStockMutation(mutation);

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mutasi stok berhasil dicatat')));

      // Update local state
      setState(() {
        _stock = StokModel(produkId: _product!.id, jumlahBarang: newStockValue);
        _currentStockController.text = newStockValue.toString();
        _changeStockController.clear();
      });

      // Go back to previous screen
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      _logError('Error updating stock', e, stackTrace);
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencatat mutasi stok: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Edit Stok',
        onPersonTap: () {
          // Handle person icon tap
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: Colors.transparent,
                      color: Warna().Putih,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Card(
                              shadowColor: Colors.transparent,
                              color: Warna().bgUtama,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  width: 1.5,
                                  color: Warna().Abu,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: 40,
                                  bottom: 40,
                                ),
                                child: Column(
                                  children: [
                                    _product != null &&
                                            _product!.imageUrl != null
                                        ? Image.network(
                                            _product!.imageUrl!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  _logError(
                                                    'Error loading product image',
                                                    error,
                                                    StackTrace.current,
                                                  );
                                                  return Icon(
                                                    Icons.image,
                                                    size: 80,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _product != null ? _product!.name : 'Nama Produk',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'CircularStd',
                              ),
                            ),

                            // Stok Sekarang field (read only)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Stok Sekarang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'CircularStd',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Warna().bgUtama,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.only(
                                  left: 17.0,
                                  right: 17.0,
                                  top: 0,
                                  bottom: 0,
                                ),
                                child: TextFormField(
                                  controller: _currentStockController,
                                  enabled: false, // Read only
                                  cursorColor: Warna().Ijo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            // Ubah Stok field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Ubah Stok',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'CircularStd',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Warna().bgUtama,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.only(
                                  left: 17.0,
                                  right: 17.0,
                                  top: 0,
                                  bottom: 0,
                                ),
                                child: TextFormField(
                                  controller: _changeStockController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Warna().Ijo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan jumlah stok baru',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'CircularStd',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Warna().Ijo,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _updateStock,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        'Simpan Perubahan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
