import 'package:flutter/material.dart';
import 'package:simulasi_ukk/Widgets/custom_back_button.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';

class EditStok extends StatefulWidget {
  @override
  _EditStokState createState() => _EditStokState();
}

class _EditStokState extends State<EditStok> {
  // Controllers for form fields
  late TextEditingController _currentStockController;
  late TextEditingController _changeStockController;

  // Product data
  Map<String, dynamic>? _productData;

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
        _productData = arguments;
        _currentStockController.text = _productData!['stockCount'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _currentStockController.dispose();
    _changeStockController.dispose();
    super.dispose();
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
                                    _productData != null &&
                                            _productData!['asset'] != null
                                        ? Image.asset(
                                            _productData!['asset'],
                                            width: 80,
                                            height: 80,
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
                                      _productData != null
                                          ? _productData!['name']
                                          : 'Nama Produk',
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
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                    )),
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
