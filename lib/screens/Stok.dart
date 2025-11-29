import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';
import 'package:simulasi_ukk/Widgets/card_produk_stok.dart';
import 'package:simulasi_ukk/Widgets/custom_search_bar.dart';

class Stok extends StatefulWidget {
  @override
  _StokState createState() => _StokState();
}

class _StokState extends State<Stok> with SingleTickerProviderStateMixin {
  int _selectedFilter = 0; // 0 for Gudang, 1 for Riwayat

  List<Map<String, dynamic>> _products = [
    {
      'name': 'Fish',
      'status': 'Menipis',
      'stockCount': '1',
      'asset': 'assets/fish.png',
      'statusColor': Warna().Oren,
      'stockCardColor': Warna().bgOren,
    },
    {
      'name': 'Book Moon',
      'status': 'Aman',
      'stockCount': '1',
      'asset': 'assets/notes.png',
      'statusColor': Warna().Ijo,
      'stockCardColor': Warna().bgIjo,
    },
    {
      'name': 'Telegram',
      'status': 'Menipis',
      'stockCount': '1',
      'asset': 'assets/legram.png',
      'statusColor': Warna().Oren,
      'stockCardColor': Warna().bgOren,
    },
    {
      'name': 'Spotify',
      'status': 'Habis',
      'stockCount': '1',
      'asset': 'assets/Spotify.png',
      'statusColor': Warna().Merah,
      'stockCardColor': Warna().bgMerah,
    },
  ];

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
                // Gudang content (original content)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomSearchBar(hintText: 'Cari Produk'),
                    ),
                    SizedBox(height: 8),
                    Center(
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
                                  color: const Color.fromARGB(
                                    175,
                                    218,
                                    218,
                                    218,
                                  ),
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
                                        '4',
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
                                  color: const Color.fromARGB(
                                    175,
                                    218,
                                    218,
                                    218,
                                  ),
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
                                        '4',
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
                                  color: const Color.fromARGB(
                                    175,
                                    218,
                                    218,
                                    218,
                                  ),
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
                                        '4',
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
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        //Card Prdoduk di stok
                        Expanded(
                          child: CardProdukStok(
                            productName: _products[0]['name'],
                            status: _products[0]['status'],
                            stockCount: _products[0]['stockCount'],
                            image: _products[0]['asset'],
                            statusColor: _products[0]['statusColor'],
                            stockCardColor: _products[0]['stockCardColor'],
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/EditStok',
                                arguments: _products[0],
                              );
                            },
                          ),
                        ),
                        Expanded(
                          //Card Produk di stok
                          child: CardProdukStok(
                            productName: _products[1]['name'],
                            status: _products[1]['status'],
                            stockCount: _products[1]['stockCount'],
                            image: _products[1]['asset'],
                            statusColor: _products[1]['statusColor'],
                            stockCardColor: _products[1]['stockCardColor'],
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/EditStok',
                                arguments: _products[1],
                              );
                            },
                          ),
                        ),

                        //Card Produk di stok
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        //Card Prdoduk di stok
                        Expanded(
                          child: CardProdukStok(
                            productName: _products[2]['name'],
                            status: _products[2]['status'],
                            stockCount: _products[2]['stockCount'],
                            image: _products[2]['asset'],
                            statusColor: _products[2]['statusColor'],
                            stockCardColor: _products[2]['stockCardColor'],
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/EditStok',
                                arguments: _products[2],
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: CardProdukStok(
                            productName: _products[3]['name'],
                            status: _products[3]['status'],
                            stockCount: _products[3]['stockCount'],
                            image: _products[3]['asset'],
                            statusColor: _products[3]['statusColor'],
                            stockCardColor: _products[3]['stockCardColor'],
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/EditStok',
                                arguments: _products[3],
                              );
                            },
                          ),
                        ),
                        //Card Produk di stok
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),

              if (_selectedFilter == 1)
                // Riwayat content (empty layout as requested)
                Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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

                      //Card stok masuk (+)
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
                                          "+3",
                                          style: TextStyle(
                                            color: Warna().Ijo,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'CircularStd',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fish',
                                          style: TextStyle(
                                            fontFamily: "CircularStd",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '13 Okt 2025, 12:00',
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
                      ),

                      //Card stok keluar (-)
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
                                          "+3",
                                          style: TextStyle(
                                            color: Warna().Merah,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'CircularStd',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Book Moon',
                                          style: TextStyle(
                                            fontFamily: "CircularStd",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '13 Okt 2025, 12:00',
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
                      ),
                    ],
                  ),
                ),
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

  void _handleNavigation(BuildContext context, int index) {
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
    }
  }
}
