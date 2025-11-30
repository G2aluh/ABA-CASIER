import 'package:simulasi_ukk/Widgets/chart-line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/Widgets/chart-line02.dart';
import 'package:simulasi_ukk/providers/auth_provider.dart';
import 'package:simulasi_ukk/screens/Login.dart';
import 'package:simulasi_ukk/screens/test_screen.dart';
import '../models/model_warna.dart';
import '../Widgets/card_satu.dart';
import '../Widgets/card_transaksi_terbaru.dart';
import '../Widgets/custom_appbar.dart';
import '../Widgets/custom_bottom_navbar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(
        title: 'Dashboard',
        onPersonTap: () {
          Navigator.pushNamed(context, '/ManajemenPelanggan');
        },
        onSettingsTap: () {
          Navigator.pushNamed(context, '/Settings');
        },
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
            padding: const EdgeInsets.only(left: 9, right: 9),
            child: Column(
              children: [
                //! Card Alert Produk
                Card(
                  shadowColor: Colors.transparent,
                  color: Warna().bgOren,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Warna().Oren, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 30,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '2 produk perlu di restok',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CircularStd',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Card(
                        shadowColor: Colors.transparent,
                        color: Warna().Ijo,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 40,
                                color: Warna().Putih,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'IDR 1.500.000',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'GeneralSans',
                                  color: Warna().Putih,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Penjualan Hari Ini',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'CircularStd',
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

                Row(
                  children: [
                    //! Card Orderan Hari ini
                    Expanded(
                      child: CardSatu(
                        icon: Icons.add_shopping_cart,
                        text: 'Orderan Hari Ini',
                        count: '12',
                        iconColor: Warna().Ijo,
                      ),
                    ),
                    //! Card Total Produk
                    Expanded(
                      child: CardSatu(
                        icon: Icons.warehouse,
                        text: 'Total Produk',
                        count: '8',
                        iconColor: Warna().Ijo,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Row(
                  children: [
                    //! Semua Transaksi
                    Expanded(
                      child: CardSatu(
                        icon: Icons.ads_click,
                        text: 'Orderan Hari Ini',
                        count: '12',
                        iconColor: Warna().Ijo,
                      ),
                    ),
                    //! Pengguna Aktif
                    Expanded(
                      child: CardSatu(
                        icon: Icons.person_pin,
                        text: 'Pelanggan Aktif',
                        count: '8',
                        iconColor: Warna().Ijo,
                      ),
                    ),
                  ],
                ),

                //! Grafik Penjualan
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Row(
                        children: [
                          Text(
                            'Grafik Penjualan Mingguan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'CircularStd',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Warna().Ijo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'untung',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Warna().Merah,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'rugi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
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
                SizedBox(height: 2),
                Card(
                  shadowColor: Colors.transparent,
                  color: Warna().Putih,
                  child: BarChartSample2(),
                ),
                //! End Grafik Penjualan
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Row(
                        children: [
                          Text(
                            'Grafik Penjualan Bulanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'CircularStd',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Warna().Ijo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'untung',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Warna().Merah,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'rugi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'CircularStd',
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
                SizedBox(height: 2),
                Card(
                  shadowColor: Colors.transparent,
                  color: Warna().Putih,
                  child: BarChartSample6(),
                ),
                //! End Grafik Penjualan Bulanan
                SizedBox(height: 10),

                //! Transaksi Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Text(
                        'Transaksi Terbaru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'CircularStd',
                        ),
                      ),
                    ),
                  ],
                ),
                CardTransaksiTerbaru(
                  transactionId: 'TRX-20220501-A1B2',
                  customerName: 'Galuh Sepurane',
                  date: '12 Juli 2022, 13:43',
                  amount: 'Rp. 330.000',
                  cashLabel: 'Tunai',
                  cashLabelColor: Warna().Ijo,
                ),
                CardTransaksiTerbaru(
                  transactionId: 'TRX-20220501-A1B2',
                  customerName: 'Ahmad Kebingungan',
                  date: '12 Juli 2022, 11:43',
                  amount: 'Rp. 150.000',
                  cashLabel: 'Tunai',
                  cashLabelColor: Warna().Ijo,
                ),
                CardTransaksiTerbaru(
                  transactionId: 'TRX-20220501-A1B2',
                  customerName: 'Dimas Disco',
                  date: '12 Juli 2022, 18:43',
                  amount: 'Rp. 190.000',
                  cashLabel: 'Ditunda',
                  cashLabelColor: Warna().Merah,
                ),
                CardTransaksiTerbaru(
                  transactionId: 'TRX-20220501-A1B2',
                  customerName: 'Galih Kulino',
                  date: '12 Juli 2022, 11:43',
                  amount: 'Rp. 150.000',
                  cashLabel: 'Tunai',
                  cashLabelColor: Warna().Ijo,
                ),
                SizedBox(height: 20),
              ],
            ),

            // ! End Transaksi Terbaru
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
          switch (index) {
            case 0:
              // Already on Dashboard screen
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
              Navigator.pushNamed(context, '/Stok');
              break;
          }
        },
      ),
    );
  }
}
