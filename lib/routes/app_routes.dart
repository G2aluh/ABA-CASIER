import 'package:flutter/material.dart';
import 'package:simulasi_ukk/screens/Dasboard.dart';
import 'package:simulasi_ukk/screens/Login.dart';
import 'package:simulasi_ukk/screens/Laporan.dart';
import 'package:simulasi_ukk/screens/ManajemenPelanggan.dart';
import 'package:simulasi_ukk/screens/Penjualan.dart' as penjualan;
import 'package:simulasi_ukk/screens/Produk.dart';
import 'package:simulasi_ukk/screens/Stok.dart';
import 'package:simulasi_ukk/screens/TambahProduk.dart';
import 'package:simulasi_ukk/screens/EditProduk.dart';
import 'package:simulasi_ukk/screens/EditStok.dart';
import 'package:simulasi_ukk/screens/Keranjang.dart';
import 'package:simulasi_ukk/screens/Settings.dart';
import 'package:simulasi_ukk/screens/PembayaranBerhasil.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/Dashboard': (BuildContext context) => Dashboard(),
    '/Login': (BuildContext context) => Login(),
    '/Laporan': (BuildContext context) => Laporan(),
    '/ManajemenPelanggan': (BuildContext context) => ManajemenPelanggan(),
    '/Penjualan': (BuildContext context) => penjualan.Penjualan(),
    '/Produk': (BuildContext context) => Produk(),
    '/Stok': (BuildContext context) => Stok(),
    '/TambahProduk': (BuildContext context) => TambahProduk(),

    '/EditStok': (BuildContext context) => EditStok(),
    '/Keranjang': (BuildContext context) => Keranjang(),
    '/Settings': (BuildContext context) => Settings(),
    '/PembayaranBerhasil': (BuildContext context) => PembayaranBerhasil(),
  };
}
