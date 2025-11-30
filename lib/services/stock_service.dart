import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/models/stok_model.dart';
import 'package:simulasi_ukk/models/stok_mutasi_model.dart';

class StockService {
  static final StockService _instance = StockService._internal();
  factory StockService() => _instance;
  StockService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  // Ambil semua stok
  Future<List<StokModel>> getStocks() async {
    final res = await _supabase
        .from('stok')
        .select()
        .order('produk_id', ascending: true);

    return res.map<StokModel>((data) => StokModel.fromJson(data)).toList();
  }

  // Ambil stok per produk ID
  Future<StokModel?> getStockByProductId(int productId) async {
    final res = await _supabase
        .from('stok')
        .select()
        .eq('produk_id', productId)
        .maybeSingle();

    if (res == null) return null;
    return StokModel.fromJson(res);
  }

  // Update atau insert stok
  Future<StokModel> updateStock(int productId, int newQty) async {
    final existing = await getStockByProductId(productId);

    final data = {
      'produk_id': productId,
      'jumlah_barang': newQty,
      'updated_at': DateTime.now().toIso8601String(),
    };

    late final Map<String, dynamic> res;

    if (existing?.id != null) {
      res = await _supabase
          .from('stok')
          .update(data)
          .eq('id', existing!.id!)
          .select()
          .single();
    } else {
      res = await _supabase
          .from('stok')
          .insert(data)
          .select()
          .single();
    }

    return StokModel.fromJson(res);
  }

  // Tambah mutasi stok (tanpa id!)
  Future<StokMutasiModel> addStockMutation(StokMutasiModel mutation) async {
    final json = mutation.toJson()
      ..remove('id'); // Hapus id supaya tidak insert ke identity column

    final res = await _supabase
        .from('stok_mutasi')
        .insert(json)
        .select()
        .single();

    return StokMutasiModel.fromJson(res);
  }

  // History mutasi stok
  Future<List<StokMutasiModel>> getStockMutations({int? limit}) async {
    var query = _supabase
        .from('stok_mutasi')
        .select()
        .order('created_at', ascending: false);

    if (limit != null) query = query.limit(limit);

    final res = await query;
    return res.map<StokMutasiModel>((e) => StokMutasiModel.fromJson(e)).toList();
  }

  // Mutasi per produk
  Future<List<StokMutasiModel>> getStockMutationsByProductId(int productId) async {
    final res = await _supabase
        .from('stok_mutasi')
        .select()
        .eq('produk_id', productId)
        .order('created_at', ascending: false);

    return res.map<StokMutasiModel>((e) => StokMutasiModel.fromJson(e)).toList();
  }

  // Realtime stok
  Stream<List<Map<String, dynamic>>> getStockStream() {
    return _supabase
        .from('stok')
        .stream(primaryKey: ['id']);
  }

  // Realtime mutasi
  Stream<List<Map<String, dynamic>>> getStockMutationStream() {
    return _supabase
        .from('stok_mutasi')
        .stream(primaryKey: ['id'])
        .order('created_at');
  }
}
