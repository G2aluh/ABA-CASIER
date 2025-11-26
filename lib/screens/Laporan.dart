import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/Widgets/custom_bottom_navbar.dart';

class Laporan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Laporan',
        onPersonTap: () {
          // Handle person icon tap
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //Tombol hari ini
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().Ijo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Putih,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  //Tombol minggu ini
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().bgIjo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Text(
                        'Minggu Ini',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Ijo,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  //Tombol bulan ini
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().bgIjo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Text(
                        'Bulan Ini',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Ijo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  //Tombol tanggal
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: Warna().Ijo,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {},
                      child: Icon(
                        Icons.date_range_outlined,
                        size: 18,
                        color: Warna().Putih,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  //Tombol unduh
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: Warna().Ijo,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                          bottom: 6,
                          left: 1,
                          right: 1,
                        ),
                        child: Icon(
                          Icons.download,
                          size: 18,
                          color: Warna().Putih,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Warna().Ijo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.document_scanner_outlined,
                              size: 24,
                              color: Warna().Putih,
                            ),
                            SizedBox(height: 6),
                            Text(
                              textAlign: TextAlign.center,
                              'IDR 200.000',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "GeneralSans",
                                fontWeight: FontWeight.w600,
                                color: Warna().Putih,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Penjualan Hari Ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "CircularStd",
                                fontWeight: FontWeight.w400,
                                color: Warna().Putih,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              //Card Item Terjual
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Warna().Putih,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Icon(
                              Icons.dataset_linked_sharp,
                              size: 28,
                              color: Warna().Ijo,
                            ),
                            SizedBox(height: 6),
                            Text(
                              textAlign: TextAlign.center,
                              '12',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "GeneralSans",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Item Terjual',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "CircularStd",
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // End card item terjual

                  //Card Total Transaksi
                  Expanded(
                    child: Card(
                      color: Warna().Putih,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Icon(Icons.dashboard, size: 28, color: Warna().Ijo),
                            SizedBox(height: 6),
                            Text(
                              textAlign: TextAlign.center,
                              '6',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "GeneralSans",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Total Transaksi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "CircularStd",
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // End Card Total Transaksi
                ],
              ),

              // Card Metode Pembayaran
              SizedBox(height: 10),
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              //Pembayaran Tunai
              Card(
                elevation: 0,
                color: Warna().Putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tunai",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "20%",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Ijo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4),
              //Pembayaran Ditunda
              Card(
                elevation: 0,
                color: Warna().Putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ditunda",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "30%",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Ijo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Card Metode Pembayaran

              // Card Laba rugi & untung
              SizedBox(height: 10),
              Text(
                'Laba Rugi & Untung',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              //Card Modal Awal
              Card(
                elevation: 0,
                color: Warna().Putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Modal",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Rp.200.000",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4),
              //Card Untung
              Card(
                elevation: 0,
                color: Warna().Putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Untung",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Rp.100.000",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Ijo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4),
              //Card Untung
              Card(
                elevation: 0,
                color: Warna().Putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rugi",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Rp.150.000",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w600,
                          color: Warna().Merah,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              // End Card Laba untung & rugi
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 3, // Index for Laporan
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
        // Already on Laporan screen
        break;
      case 4:
        Navigator.pushNamed(context, '/Stok');
        break;
    }
  }
}
