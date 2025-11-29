import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() {
    debugPrint('ProductService factory called');
    return _instance;
  }
  ProductService._internal() {
    debugPrint('ProductService internal constructor called');
  }

  late SupabaseClient _supabase;

  // Initialize the Supabase client
  void _ensureInitialized() {
    try {
      debugPrint('Ensuring ProductService is initialized with Supabase client');
      _supabase = SupabaseService().supabase;
      debugPrint('ProductService Supabase client initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing ProductService Supabase client: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Get all products (excluding deleted ones)
  Future<List<ProductModel>> getProducts() async {
    try {
      _ensureInitialized();
      debugPrint('Fetching products from Supabase');

      final response = await _supabase
          .from('produk')
          .select()
          .filter('deleted_at', 'is', null)
          .order('produkid');

      debugPrint('Products fetched successfully, count: ${response.length}');

      return response.map((data) => ProductModel.fromJson(data)).toList();
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch products: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(int productId) async {
    try {
      _ensureInitialized();
      debugPrint('Fetching product with ID: $productId');

      final response = await _supabase
          .from('produk')
          .select()
          .eq('produkid', productId)
          .single();

      debugPrint('Product with ID $productId fetched successfully');

      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch product: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // Get soft deleted products
  Future<List<ProductModel>> getSoftDeletedProducts() async {
    try {
      _ensureInitialized();
      debugPrint('Fetching soft deleted products from Supabase');

      final response = await _supabase
          .from('produk')
          .select()
          .not('deleted_at', 'is', null)
          .order('produkid');

      debugPrint(
        'Soft deleted products fetched successfully, count: ${response.length}',
      );

      return response.map((data) => ProductModel.fromJson(data)).toList();
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch soft deleted products: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch soft deleted products: $e');
    }
  }

  // Add a new product
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      _ensureInitialized();
      debugPrint('Adding new product: ${product.name}');

      final productJson = product.toJsonForInsert();
      final response = await _supabase
          .from('produk')
          .insert(productJson)
          .select()
          .single();

      debugPrint('Product added successfully with ID: ${response['produkid']}');

      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('Failed to add product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to add product: $e');
    }
  }

  // Update a product
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      _ensureInitialized();
      debugPrint('Updating product with ID: ${product.id}');

      final productJson = product.toJsonForUpdate();
      final response = await _supabase
          .from('produk')
          .update(productJson)
          .eq('produkid', product.id!)
          .select()
          .single();

      debugPrint('Product updated successfully');

      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('Failed to update product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to update product: $e');
    }
  }

  // Soft delete a product (set deleted_at timestamp)
  Future<void> deleteProduct(int productId) async {
    try {
      _ensureInitialized();
      debugPrint('Soft deleting product with ID: $productId');

      await _supabase
          .from('produk')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('produkid', productId);

      debugPrint('Product soft deleted successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to soft delete product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to soft delete product: $e');
    }
  }

  // Restore a soft deleted product (clear deleted_at timestamp)
  Future<void> restoreProduct(int productId) async {
    try {
      _ensureInitialized();
      debugPrint('Restoring product with ID: $productId');

      await _supabase
          .from('produk')
          .update({'deleted_at': null})
          .eq('produkid', productId);

      debugPrint('Product restored successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to restore product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to restore product: $e');
    }
  }

  // Permanently delete a product
  Future<void> permanentlyDeleteProduct(int productId) async {
    try {
      _ensureInitialized();
      debugPrint('Permanently deleting product with ID: $productId');

      await _supabase.from('produk').delete().eq('produkid', productId);

      debugPrint('Product permanently deleted successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to permanently delete product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to permanently delete product: $e');
    }
  }

  // Upload product image to Supabase storage
  Future<String?> uploadProductImage(Uint8List bytes, String fileName) async {
    try {
      _ensureInitialized();
      debugPrint('Uploading product image: $fileName');
      debugPrint('Image bytes length: ${bytes.length}');

      await _supabase.storage.from('item').uploadBinary(fileName, bytes);

      // Get public URL for the uploaded image
      final url = _supabase.storage.from('item').getPublicUrl(fileName);
      debugPrint('Image uploaded successfully');
      debugPrint('Generated URL: $url');

      return url;
    } catch (e, stackTrace) {
      debugPrint('Failed to upload image: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return a more descriptive error
      throw Exception('Gagal mengunggah gambar: $e');
    }
  }

  // Get real-time product stream with proper filtering
  Stream<List<Map<String, dynamic>>> getProductStream() {
    _ensureInitialized();
    debugPrint('Creating product stream with real-time updates');

    // Create the stream without filtering first
    return _supabase
        .from('produk')
        .stream(primaryKey: ['produkid'])
        .map(
          (list) => list.where((data) => data['deleted_at'] == null).toList(),
        );
  }

  // Get real-time stream for soft deleted products
  Stream<List<Map<String, dynamic>>> getSoftDeletedProductStream() {
    _ensureInitialized();
    debugPrint('Creating soft deleted product stream with real-time updates');

    // Create the stream for soft deleted products
    return _supabase
        .from('produk')
        .stream(primaryKey: ['produkid'])
        .map(
          (list) => list.where((data) => data['deleted_at'] != null).toList(),
        );
  }
}
