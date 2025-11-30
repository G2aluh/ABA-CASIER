import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_warna.dart';
import '../models/pelanggan_model.dart';
import '../providers/customer_provider.dart';
import '../utils/rupiah.dart';
import '../Widgets/custom_appbar.dart';
import '../Widgets/custom_back_button.dart';
import '../Widgets/custom_search_bar.dart';

class ManajemenPelanggan extends StatefulWidget {
  @override
  State<ManajemenPelanggan> createState() => _ManajemenPelangganState();
}

class _ManajemenPelangganState extends State<ManajemenPelanggan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Variable to hold the customer being edited
  PelangganModel? _editingCustomer;

  // Filter customers based on search query
  List<PelangganModel> _filterCustomers(
    List<PelangganModel> customers,
    String query,
  ) {
    if (query.isEmpty) return customers;
    return customers.where((customer) {
      final customerName = customer.namaPelanggan.toLowerCase();
      final customerPhone = (customer.noTelp ?? '').toLowerCase();
      final customerAddress = (customer.alamat ?? '').toLowerCase();
      final searchQuery = query.toLowerCase();

      return customerName.contains(searchQuery) ||
          customerPhone.contains(searchQuery) ||
          customerAddress.contains(searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load customers when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomers();
    });
  }

  // Load customers from the provider
  void _loadCustomers() {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );
    customerProvider.getCustomers();
  }

  // Clear all text fields
  void _clearTextFields() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
  }

  // Populate text fields with customer data for editing
  void _populateTextFields(PelangganModel customer) {
    _nameController.text = customer.namaPelanggan;
    _phoneController.text = customer.noTelp ?? '';
    _addressController.text = customer.alamat ?? '';
  }

  // Add a new customer
  void _addCustomer() async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    try {
      final newCustomer = PelangganModel(
        namaPelanggan: _nameController.text,
        alamat: _addressController.text.isNotEmpty
            ? _addressController.text
            : null,
        noTelp: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        totalPembelian: 0, // Default value
      );

      await customerProvider.addCustomer(newCustomer);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pelanggan berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      _clearTextFields();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan pelanggan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Update an existing customer
  void _updateCustomer(PelangganModel customer) async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    try {
      final updatedCustomer = PelangganModel(
        pelangganId: customer.pelangganId,
        namaPelanggan: _nameController.text,
        alamat: _addressController.text.isNotEmpty
            ? _addressController.text
            : customer.alamat,
        noTelp: _phoneController.text.isNotEmpty
            ? _phoneController.text
            : customer.noTelp,
        totalPembelian: customer.totalPembelian,
      );

      await customerProvider.updateCustomer(updatedCustomer);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pelanggan berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      _clearTextFields();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui pelanggan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Delete a customer
  void _deleteCustomer(PelangganModel customer) async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    try {
      await customerProvider.deleteCustomer(customer.pelangganId!);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pelanggan berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus pelanggan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddCustomerDialog() {
    _clearTextFields();
    _editingCustomer = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Warna().Putih,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah Pelanggan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CircularStd',
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Warna().Hitam, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  _nameController,
                  'Nama Pelanggan',
                  Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(_phoneController, 'Nomor Telepon', Icons.phone),
                SizedBox(height: 10),
                _buildTextField(
                  _addressController,
                  'Alamat',
                  Icons.location_on,
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _addCustomer();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Warna().Ijo,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'CircularStd',
                      color: Warna().Putih,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditCustomerDialog(PelangganModel customer) {
    _editingCustomer = customer;
    _populateTextFields(customer);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Warna().Putih,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Pelanggan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CircularStd',
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Warna().Hitam, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  _nameController,
                  'Nama Pelanggan',
                  Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(_phoneController, 'Nomor Telepon', Icons.phone),
                SizedBox(height: 10),
                _buildTextField(
                  _addressController,
                  'Alamat',
                  Icons.location_on,
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  //Tombol Hapus
                  ElevatedButton(
                    onPressed: () {
                      _confirmDeleteCustomer(context, customer);
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Warna().MerahGelap,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'CircularStd',
                          color: Warna().Putih,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  //Tombol Simpan
                  ElevatedButton(
                    onPressed: () {
                      _updateCustomer(customer);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Warna().Ijo,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'CircularStd',
                          color: Warna().Putih,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Warna().Putih,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Pelanggan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CircularStd',
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Warna().Hitam, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      //Card riwayat pelanggan
                      child: Card(
                        color: Warna().bgUtama,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TRX-20112025-001',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '2025-11-20, 13:00',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Card(),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                              // Text in top-right corner
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Text(
                                  RupiahFormatter.format(200000),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Warna().Ijo,
                                  ),
                                ),
                              ),
                              // Card in bottom-right corner
                              SizedBox(height: 2),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Card(
                                  elevation: 0,
                                  color: Warna().bgIjo,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      'Tunai',
                                      style: TextStyle(
                                        fontFamily: 'CircularStd',
                                        fontSize: 9,
                                        color: Warna().Ijo,
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      cursorColor: Warna().Hitam,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'CircularStd',
      ),
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Warna().Hitam),
          borderRadius: BorderRadius.circular(6),
        ),
        filled: true,
        fillColor: Warna().bgUtama,
        labelText: label,
        labelStyle: TextStyle(
          color: Warna().Hitam,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'CircularStd',
        ),
        prefixIcon: Icon(icon, size: 18),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  void _confirmDeleteCustomer(BuildContext context, PelangganModel customer) {
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
                'Hapus Pelanggan',
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
              text: 'Apakah Anda yakin ingin menghapus ',
              children: [
                TextSpan(
                  text: customer.namaPelanggan,
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
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  _deleteCustomer(customer);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Pelanggan',
        onPersonTap: () {
          // Handle person icon tap
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              // Search bar
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomSearchBar(
                  controller: _searchController,
                  hintText: 'Cari Pelanggan...',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),

              SizedBox(height: 10),

              // Display list of customers using StreamBuilder for real-time updates
              StreamBuilder<List<PelangganModel>>(
                stream: Provider.of<CustomerProvider>(
                  context,
                  listen: false,
                ).customersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while establishing connection
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
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada pelanggan',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  // Filter customers based on search query
                  final filteredCustomers = _filterCustomers(
                    snapshot.data!,
                    _searchController.text,
                  );

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          shadowColor: Colors.transparent,
                          color: Warna().Putih,
                          child: GestureDetector(
                            onTap: () {
                              _showCustomerHistoryDialog();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Card(
                                      elevation: 0,
                                      color: Warna().Ijo,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          top: 4,
                                          bottom: 4,
                                        ),
                                        child: Text(
                                          RupiahFormatter.format(
                                            customer.totalPembelian ?? 0,
                                          ),
                                          style: TextStyle(
                                            color: Warna().Putih,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'CircularStd',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customer.namaPelanggan,
                                        style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        'Wa: ${customer.noTelp ?? '-'}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        'Alamat: ${customer.alamat ?? '-'}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 28,
                                    child: IconButton(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.edit,
                                        color: Warna().Ijo,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _showEditCustomerDialog(customer);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        highlightElevation: 0,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: _showAddCustomerDialog,
        backgroundColor: Warna().Ijo,
        child: Icon(Icons.add, color: Warna().Putih),
      ),
      bottomNavigationBar: null,
    );
  }
}
