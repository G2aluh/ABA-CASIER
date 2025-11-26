import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';

class Keranjang extends StatefulWidget {
  final List<Map<String, dynamic>>? selectedProducts;

  const Keranjang({Key? key, this.selectedProducts}) : super(key: key);

  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  late List<Map<String, dynamic>> _cartItems;
  String _selectedCustomer = 'Walk in Customer';
  String _selectedPaymentMethod = 'Tunai';
  final List<String> _customerOptions = ['Lang', 'Walk in Customer'];
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get products from arguments if available, otherwise use passed products or empty list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is List<Map<String, dynamic>>) {
        setState(() {
          _cartItems = List.from(args);
        });
      } else {
        _cartItems = widget.selectedProducts != null
            ? List.from(widget.selectedProducts!)
            : [];
      }
    });
    _cartItems = widget.selectedProducts != null
        ? List.from(widget.selectedProducts!)
        : [];
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  num _calculateTotal() {
    num total = 0;
    for (var item in _cartItems) {
      // Extract numeric value from price string (e.g., "Rp200.000" -> 200000)
      String priceString = item['price'].toString().replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      total += int.tryParse(priceString) ?? 0;
    }
    return total;
  }

  String _formatPrice(num price) {
    // Simple formatting without intl package
    String priceString = price.toString();
    if (priceString.length <= 3) return priceString;

    List<String> parts = [];
    for (int i = priceString.length; i > 0; i -= 3) {
      int start = i - 3 > 0 ? i - 3 : 0;
      parts.insert(0, priceString.substring(start, i));
    }
    return parts.join('.');
  }

  void _showPaymentConfirmationDialog(BuildContext context) {
    // Get discount value from the text field
    String discountValue = _discountController.text.isEmpty
        ? "0"
        : _discountController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Warna().Putih,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selesaikan Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'CircularStd',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konfirmasi Pembayaran :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'CircularStd',
                  ),
                ),
                SizedBox(height: 10),
                // Display selected items
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Warna().bgUtama,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image(
                                image: AssetImage(item['image'] ?? ''),
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? 'Produk',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'CircularStd',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    item['price'] ?? 'Rp0',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'CircularStd',
                                      color: Warna().Ijo,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Rp${_formatPrice(_calculateTotal())}',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                        color: Warna().Hitam,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Diskon:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Rp$discountValue',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                        color: Warna().Hitam,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metode Pembayaran:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      _selectedPaymentMethod,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                        color: Warna().Hitam,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'CircularStd',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Rp${_formatPrice(_calculateTotal())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CircularStd',

                        fontWeight: FontWeight.bold,
                        color: Warna().Hitam,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Process the payment
                      Navigator.of(context).pop(); // Close dialog
                      _processPayment();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().Ijo,
                      foregroundColor: Warna().Putih,
                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Beli',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _processPayment() {
    // Clear cart after successful payment
    setState(() {
      _cartItems.clear();
    });

    // Navigate to payment success page
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/PembayaranBerhasil',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        showBackButton: true,
        title: 'Keranjang',
        onPersonTap: () {
          // Handle person icon tap
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
                    child: Text(
                      'Keranjang kosong',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      // Product cards
                      ...List.generate(_cartItems.length, (index) {
                        final item = _cartItems[index];
                        return Card(
                          color: Warna().Putih,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                  child: Image(
                                    image: AssetImage(item['image'] ?? ''),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Product details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item['name'] ?? 'Produk',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'CircularStd',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Card(
                                            color: Warna().bgIjo,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 2,
                                                bottom: 2,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Stok: 8',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Warna().Ijo,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'CircularStd',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        item['price'] ?? 'Rp0',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          color: Warna().Ijo,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Remove button
                                IconButton(
                                  onPressed: () => _removeItem(index),
                                  icon: Icon(Icons.close, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      if (_cartItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Total :',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "GeneralSans",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    ' Rp${_formatPrice(_calculateTotal())}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "GeneralSans",
                                      fontWeight: FontWeight.w500,
                                      color: Warna().Ijo,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),

                              //Field Diskon
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      'Diskon',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'CircularStd',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  controller: _discountController,
                                  cursorColor: Warna().Ijo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Warna().Putih,
                                    hintText: 'Masukkan Diskon (Opsional)',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'CircularStd',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),

                              // Field Pembeli
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      'Pembeli',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                    color: Warna().Putih,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        value: _selectedCustomer,
                                        hint: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 2,
                                          ),
                                          child: Text(
                                            'Pilih Pembeli',
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
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedCustomer = newValue;
                                            });
                                          }
                                        },
                                        items: _customerOptions
                                            .map<DropdownMenuItem<String>>((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 2,
                                                      ),
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Metode Pembayaran',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'CircularStd',
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedPaymentMethod =
                                                    'Tunai';
                                              });
                                            },
                                            child: Card(
                                              color:
                                                  _selectedPaymentMethod ==
                                                      'Tunai'
                                                  ? Warna().Ijo
                                                  : Warna().bgIjo,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              elevation: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 35,
                                                  right: 35,
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  'Tunai',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        _selectedPaymentMethod ==
                                                            'Tunai'
                                                        ? Warna().Putih
                                                        : Warna().Ijo,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'CircularStd',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedPaymentMethod =
                                                    'Ditunda';
                                              });
                                            },
                                            child: Card(
                                              color:
                                                  _selectedPaymentMethod ==
                                                      'Ditunda'
                                                  ? Warna().Ijo
                                                  : Warna().bgIjo,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              elevation: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 35,
                                                  right: 35,
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  'Ditunda',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        _selectedPaymentMethod ==
                                                            'Ditunda'
                                                        ? Warna().Putih
                                                        : Warna().Ijo,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'CircularStd',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              //Tombol Checkout
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Show payment confirmation dialog
                                    _showPaymentConfirmationDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Warna().Ijo,
                                    foregroundColor: Warna().Putih,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.all(20  ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    'Checkout Sekarang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "CircuarStd",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
