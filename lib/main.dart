import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/providers/auth_provider.dart';
import 'package:simulasi_ukk/providers/database_provider.dart';
import 'package:simulasi_ukk/providers/product_provider.dart';
import 'package:simulasi_ukk/providers/stock_provider.dart';
import 'package:simulasi_ukk/routes/app_routes.dart';
import 'package:simulasi_ukk/screens/Dasboard.dart';
import 'package:simulasi_ukk/screens/Keranjang.dart';
import 'package:simulasi_ukk/screens/Laporan.dart';
import 'package:simulasi_ukk/screens/PembayaranBerhasil.dart';
import 'package:simulasi_ukk/screens/Penjualan.dart';
import 'package:simulasi_ukk/screens/SplashScreen.dart';
import 'package:simulasi_ukk/screens/Stok.dart';
import 'package:simulasi_ukk/screens/EditStok.dart';
import 'package:simulasi_ukk/screens/Login.dart';

import 'package:simulasi_ukk/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: AppRoutes.routes,
    );
  }
}
