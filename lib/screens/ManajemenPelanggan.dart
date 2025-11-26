import 'package:flutter/material.dart';
import '../models/model_warna.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showAddCustomerDialog() {
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
                _buildTextField(_emailController, 'Email', Icons.email),
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
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle add customer logic here
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
            ),
          ],
        );
      },
    );
  }

  void _showEditCustomerDialog() {
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
                _buildTextField(_emailController, 'Email', Icons.email),
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
              child: Expanded(
                child: Row(
                  children: [
                    //Tombol Hapus
                    ElevatedButton(
                      onPressed: () {
                        _confirmDeleteCustomer(context);
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
                        // Handle edit customer logic here
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
                                  'Rp. 200.000',
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

    void _confirmDeleteCustomer(BuildContext context) {
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
                text: 'Apakah Anda yakin ingin menghapus',
                children: [
                  TextSpan(
                    text: ' Lang(Nama Pelanggan)',
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

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pelanggan berhasil dihapus!'),
                        backgroundColor: Colors.green,
                      ),
                    );
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
                child: CustomSearchBar(hintText: 'Cari Pelanggan...'),
              ),

              SizedBox(height: 10),
              Card(
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
                                "Rp. 200.000",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lang',
                              style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              'Wa: 085236595907',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              'Gmail: example@gmail.com',
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
                              _showEditCustomerDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
