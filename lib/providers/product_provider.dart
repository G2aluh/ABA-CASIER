import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/product_model.dart';
import 'package:simulasi_ukk/services/product_service.dart';
import 'dart:typed_data';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductModel> _products = [];

  // Stream for real-time updates
  late Stream<List<ProductModel>> _productsStream;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductModel> get products => _products;

  // Getter for the products stream
  Stream<List<ProductModel>> get productsStream => _productsStream;

  ProductProvider() {
    // Initialize the stream when the provider is created
    _initStream();
  }

  // Initialize the real-time stream
  void _initStream() {
    _productsStream = _productService.getProductStream().map(
      (list) => list.map((data) => ProductModel.fromJson(data)).toList(),
    );
  }

  // Get stream for soft deleted products
  Stream<List<ProductModel>> getSoftDeletedProductStream() {
    return _productService.getSoftDeletedProductStream().map(
      (list) => list.map((data) => ProductModel.fromJson(data)).toList(),
    );
  }

  // Get all products (manual fetch)
  Future<void> getProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get soft deleted products
  Future<List<ProductModel>> getSoftDeletedProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final softDeletedProducts = await _productService
          .getSoftDeletedProducts();
      _isLoading = false;
      notifyListeners();
      return softDeletedProducts;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add a new product
  Future<ProductModel> addProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProduct = await _productService.addProduct(product);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return newProduct;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update a product
  Future<ProductModel> updateProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await _productService.updateProduct(product);
      // Update the product in the list
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      _isLoading = false;
      notifyListeners();
      return updatedProduct;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete a product (soft delete)
  Future<void> deleteProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.deleteProduct(productId);
      // Remove the product from the list
      _products.removeWhere((product) => product.id == productId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Restore a soft deleted product
  Future<void> restoreProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.restoreProduct(productId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Permanently delete a product
  Future<void> permanentlyDeleteProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.permanentlyDeleteProduct(productId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Show quick alert/snackbar
  void showQuickAlert(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Upload product image
  Future<String?> uploadProductImage(
    Uint8List imageBytes,
    String fileName,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _productService.uploadProductImage(
        imageBytes,
        fileName,
      );
      _isLoading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
