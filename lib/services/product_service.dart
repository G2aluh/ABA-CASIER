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
      debugPrint('Deleting product with ID: $productId');

      await _supabase
          .from('produk')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('produkid', productId);

      debugPrint('Product deleted successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to delete product: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to delete product: $e');
    }
  }

  // Upload product image to Supabase storage
  Future<String?> uploadProductImage(Uint8List bytes, String fileName) async {
    try {
      _ensureInitialized();
      debugPrint('Uploading product image: $fileName');

      await _supabase.storage.from('item').uploadBinary(fileName, bytes);

      // Get public URL for the uploaded image
      final url = _supabase.storage.from('item').getPublicUrl(fileName);
      debugPrint('Image uploaded successfully');

      return url;
    } catch (e, stackTrace) {
      debugPrint('Failed to upload image: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // Get real-time product stream
  Stream<List<ProductModel>> getProductStream() {
    _ensureInitialized();
    debugPrint('Creating product stream');

    return _supabase
        .from('produk')
        .stream(primaryKey: ['produkid'])
        .map(
          (list) => list
              .where((data) => data['deleted_at'] == null)
              .map((data) => ProductModel.fromJson(data))
              .toList(),
        );
  }
}
