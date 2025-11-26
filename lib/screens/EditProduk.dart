import 'package:flutter/material.dart';
import 'package:simulasi_ukk/Widgets/custom_back_button.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';

class EditProduk extends StatefulWidget {
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  String? _selectedCategory;
  final List<String> _categories = ['Game', 'Musik', 'Produktif'];

  // Controllers for form fields
  late TextEditingController _productNameController;
  late TextEditingController _priceController;

  // Product data
  Map<String, dynamic>? _productData;

  // Image path
  String? _imagePath;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _productNameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the product data passed from the previous screen
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      setState(() {
        _productData = arguments;
        _productNameController.text = _productData!['name'] ?? '';
        _priceController.text = _productData!['price'] ?? '';
        _selectedCategory = _productData!['category'];
        _imagePath = _productData!['image'];
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Edit Produk',
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
                                  top: 30,
                                  bottom: 30,
                                ),
                                child: Column(
                                  children: [
                                    _imagePath != null
                                        ? Image.asset(
                                            _imagePath!,
                                            width: 80,
                                            height: 80,
                                          )
                                        : Icon(
                                            Icons.camera_alt,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                    SizedBox(height: 10),
                                    Text(
                                      _imagePath != null
                                          ? 'Ganti Foto'
                                          : 'Tambah Foto',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'CircularStd',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Nama Produk field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Nama Produk',
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
                                  controller: _productNameController,
                                  cursorColor: Warna().Ijo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Nama Produk',
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

                            // Harga Produk field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Harga Produk',
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
                                  controller: _priceController,
                                  cursorColor: Warna().Ijo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Harga Produk',
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

                            //Kategori field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Kategori',
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
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          'Pilih Kategori',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'CircularStd',
                                          ),
                                        ),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 17,
                                        ),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      isExpanded: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCategory = newValue;
                                        });
                                      },
                                      items: _categories
                                          .map<DropdownMenuItem<String>>((
                                            String value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 2,
                                                ),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'CircularStd',
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                          .toList(),
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 0,
                                      dropdownColor: Warna().Putih,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Warna().Ijo,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Simpan Perubahan',
                                          style: TextStyle(
                                            color: Warna().Putih,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'CircularStd',
                                          ),
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
