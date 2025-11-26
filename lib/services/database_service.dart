import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';
import 'package:simulasi_ukk/models/user_model.dart';
import 'package:simulasi_ukk/models/product_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final SupabaseClient _supabase = SupabaseService().supabase;

  // Get all users
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _supabase.from('users').select();
      return response.map((data) => UserModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Add a new user
  Future<void> addUser(UserModel user) async {
    try {
      // For new users, we should not include the id field so the database can auto-generate it
      final userJson = user.toJson();
      if (user.id.isEmpty) {
        userJson.remove('id');
      }
      await _supabase.from('users').insert(userJson);
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // Update a user
  Future<void> updateUser(UserModel user) async {
    try {
      // For updates, we exclude the id from the update data
      final userJson = user.toJson();
      userJson.remove('id');
      userJson['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('users').update(userJson).eq('id', user.id);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await _supabase.from('users').delete().eq('id', userId);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Get user by ID
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Failed to fetch user: $e');
      return null;
    }
  }

  // Product CRUD operations

  // Get all products with stock information
  Future<List<ProductModel>> getProducts() async {
    try {
      // Join produk table with stok table to get stock information
      final response = await _supabase
          .from('produk')
          .select('*, stok(jumlah_barang)')
          .is_('deleted_at', null); // Only get non-deleted products

      return response.map((data) {
        // Extract stock from the joined stok table
        int? stock;
        if (data['stok'] != null && data['stok'].length > 0) {
          stock = data['stok'][0]['jumlah_barang'] as int?;
        }

        return ProductModel(
          id: data['produkid']?.toString() ?? '',
          name: data['namaproduk'] ?? '',
          price: data['harga'] ?? 0,
          imageUrl: data['gambar_url'],
          category: data['kategori_produk'],
          deletedAt: data['deleted_at'] != null
              ? DateTime.parse(data['deleted_at'])
              : null,
          recoveryAt: data['recovery_at'] != null
              ? DateTime.parse(data['recovery_at'])
              : null,
          stock: stock,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Add a new product
  Future<void> addProduct(ProductModel product) async {
    try {
      final productJson = product.toJson();
      productJson.remove('produkid'); // Remove id to let DB auto-generate

      final response = await _supabase
          .from('produk')
          .insert(productJson)
          .select();

      // If product was added successfully, also create an entry in stok table
      if (response.isNotEmpty) {
        final productId = response[0]['produkid'];
        await _supabase.from('stok').insert({
          'produk_id': productId,
          'jumlah_barang': 0, // Initial stock is 0
        });
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update a product
  Future<void> updateProduct(ProductModel product) async {
    try {
      final productJson = product.toJson();
      productJson.remove('produkid'); // Remove id from update data
      productJson.remove('stok'); // Stock is managed separately in stok table

      await _supabase
          .from('produk')
          .update(productJson)
          .eq('produkid', product.id);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product (soft delete)
  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase
          .from('produk')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('produkid', productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Update product stock
  Future<void> updateProductStock(String productId, int newStock) async {
    try {
      // First check if stok entry exists for this product
      final stokResponse = await _supabase
          .from('stok')
          .select()
          .eq('produk_id', productId);

      if (stokResponse.isEmpty) {
        // If no stok entry exists, create one
        await _supabase.from('stok').insert({
          'produk_id': productId,
          'jumlah_barang': newStock,
        });
      } else {
        // Update existing stok entry
        await _supabase
            .from('stok')
            .update({'jumlah_barang': newStock})
            .eq('produk_id', productId);
      }

      // Also insert a record in stok_mutasi table
      await _supabase.from('stok_mutasi').insert({
        'produk_id': productId,
        'qty': newStock,
        'jenis_mutasi': 'adjustment', // Could be 'in', 'out', or 'adjustment'
        'keterangan': 'Stock updated via app',
      });
    } catch (e) {
      throw Exception('Failed to update product stock: $e');
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final response = await _supabase
          .from('produk')
          .select('*, stok(jumlah_barang)')
          .eq('produkid', productId)
          .single();

      // Extract stock from the joined stok table
      int? stock;
      if (response['stok'] != null && response['stok'].length > 0) {
        stock = response['stok'][0]['jumlah_barang'] as int?;
      }

      return ProductModel(
        id: response['produkid']?.toString() ?? '',
        name: response['namaproduk'] ?? '',
        price: response['harga'] ?? 0,
        imageUrl: response['gambar_url'],
        category: response['kategori_produk'],
        deletedAt: response['deleted_at'] != null
            ? DateTime.parse(response['deleted_at'])
            : null,
        recoveryAt: response['recovery_at'] != null
            ? DateTime.parse(response['recovery_at'])
            : null,
        stock: stock,
      );
    } catch (e) {
      print('Failed to fetch product: $e');
      return null;
    }
  }

  // Set up real-time listener for products
  Stream<List<Map<String, dynamic>>> streamProducts() {
    return _supabase
        .from('produk')
        .stream(primaryKey: ['produkid'])
        .eq('deleted_at', null);
  }

  // Set up real-time listener for stock
  Stream<List<Map<String, dynamic>>> streamStock() {
    return _supabase.from('stok').stream(primaryKey: ['id']);
  }
}
