import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:simulasi_ukk/Widgets/custom_back_button.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/providers/product_provider.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/utils/rupiah.dart';

class TambahProduk extends StatefulWidget {
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  String? _selectedCategory;
  final List<String> _categories = ['Game', 'Musik', 'Produktif'];

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _rawPriceValue = '';

  // Image picker
  File? _pickedImage;
  Uint8List? _pickedImageBytes; // For web compatibility
  final ImagePicker _picker = ImagePicker();

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      print('Attempting to pick image from gallery');
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Image picked successfully, path: ${pickedFile.path}');
        setState(() {
          _pickedImage = File(pickedFile.path);
          // For web compatibility, we also store the bytes
          pickedFile
              .readAsBytes()
              .then((bytes) {
                print('Image bytes read successfully, length: ${bytes.length}');
                setState(() {
                  _pickedImageBytes = bytes;
                });
              })
              .catchError((error) {
                print('Error reading image bytes: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal membaca gambar: $error')),
                );
              });
        });
      } else {
        print('No image was picked');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  // Upload image and save product
  Future<void> _saveProduct() async {
    // Validate inputs
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nama produk harus diisi')));
      return;
    }

    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Harga produk harus diisi')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kategori harus dipilih')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;

      // Upload image if selected
      if (_pickedImageBytes != null) {
        final productProvider = Provider.of<ProductProvider>(
          context,
          listen: false,
        );
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await productProvider.uploadProductImage(
          _pickedImageBytes!,
          fileName,
        );

        if (imageUrl == null) {
          throw Exception('Gagal mengunggah gambar');
        }
      }

      // Use category string directly
      String? category = _selectedCategory;

      // Create product model
      final product = ProductModel(
        name: _nameController.text,
        price: int.tryParse(_rawPriceValue) ?? 0,
        imageUrl: imageUrl,
        category: category,
      );

      // Save product
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      await productProvider.addProduct(product);

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Produk berhasil ditambahkan')));

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      print('Error saving product: $e');
      print('Error type: ${e.runtimeType}');
      // Show a more user-friendly error message
      String errorMessage = 'Gagal menyimpan produk';
      if (e.toString().contains('Gagal mengunggah gambar')) {
        errorMessage =
            'Gagal mengunggah gambar. Pastikan koneksi internet Anda stabil dan coba lagi.';
      } else if (e.toString().contains('Failed to upload image')) {
        errorMessage =
            'Gagal mengunggah gambar. Periksa ukuran file dan koneksi internet Anda.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Tambah Produk',
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
                            GestureDetector(
                              onTap: _pickImage,
                              child: Card(
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
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      _pickedImageBytes != null
                                          ? Image.memory(
                                              _pickedImageBytes!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.camera_alt,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _pickedImageBytes != null
                                  ? 'Ganti Foto'
                                  : 'Tambah Foto',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'CircularStd',
                              ),
                            ),
                            SizedBox(height: 8),
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
                                  controller: _nameController,
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _priceController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
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
                                        onChanged: (value) {
                                          // Store raw value for submission
                                          _rawPriceValue = value;

                                          // Format the value as Rupiah while typing
                                          if (value.isNotEmpty) {
                                            final numericValue =
                                                int.tryParse(value) ?? 0;
                                            final formattedValue =
                                                RupiahFormatter.format(
                                                  numericValue,
                                                );

                                            // Update the text field with formatted value
                                            // But keep cursor position at the end
                                            _priceController
                                                .value = TextEditingValue(
                                              text: formattedValue,
                                              selection:
                                                  TextSelection.collapsed(
                                                    offset:
                                                        formattedValue.length,
                                                  ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
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
                                  child: GestureDetector(
                                    onTap: _saveProduct,
                                    child: Card(
                                      color: _isLoading
                                          ? Warna().Abu
                                          : Warna().Ijo,
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
                                          child: _isLoading
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                )
                                              : Text(
                                                  'Tambah Produk',
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
