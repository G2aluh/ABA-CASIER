import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/stok_model.dart';
import 'package:simulasi_ukk/models/stok_mutasi_model.dart';
import 'package:simulasi_ukk/services/stock_service.dart';

class StockProvider with ChangeNotifier {
  final StockService _stockService = StockService();

  bool _isLoading = false;
  String? _errorMessage;
  List<StokModel> _stocks = [];
  List<StokMutasiModel> _stockMutations = [];

  // Streams for real-time updates
  late Stream<List<StokModel>> _stocksStream;
  late Stream<List<StokMutasiModel>> _stockMutationsStream;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<StokModel> get stocks => _stocks;
  List<StokMutasiModel> get stockMutations => _stockMutations;

  // Getters for streams
  Stream<List<StokModel>> get stocksStream => _stocksStream;
  Stream<List<StokMutasiModel>> get stockMutationsStream =>
      _stockMutationsStream;

  StockProvider() {
    // Initialize the streams when the provider is created
    _initStreams();
    // Listen to streams for real-time updates
    _stocksStream.listen((stocks) {
      _stocks = stocks;
      notifyListeners();
    });

    // Listen to stock mutation updates
    _stockMutationsStream.listen((mutations) {
      _stockMutations = mutations;
      notifyListeners();
    });
  }

  // Helper method to log errors with detailed information
  _logError(String context, Object error, StackTrace stackTrace) {
    print('=== STOCK PROVIDER ERROR ===');
    print('Context: $context');
    print('Error: $error');
    print('Stack Trace: $stackTrace');
    print('Timestamp: ${DateTime.now()}');
    print('============================');
  }

  // Initialize the real-time streams
  void _initStreams() {
    try {
      _stocksStream = _stockService.getStockStream().map((list) {
        try {
          return list.map((data) => StokModel.fromJson(data)).toList();
        } catch (e, stackTrace) {
          _logError('Error mapping stock stream data', e, stackTrace);
          return <StokModel>[];
        }
      });

      _stockMutationsStream = _stockService.getStockMutationStream().map((
        list,
      ) {
        try {
          return list.map((data) => StokMutasiModel.fromJson(data)).toList();
        } catch (e, stackTrace) {
          _logError('Error mapping stock mutation stream data', e, stackTrace);
          return <StokMutasiModel>[];
        }
      });
    } catch (e, stackTrace) {
      _logError('Error initializing streams', e, stackTrace);
    }
  }

  // Get all stocks (manual fetch)
  Future<void> getStocks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stocks = await _stockService.getStocks();
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _logError('Error fetching stocks', e, stackTrace);
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get stock by product ID
  Future<StokModel?> getStockByProductId(int productId) async {
    try {
      return await _stockService.getStockByProductId(productId);
    } catch (e, stackTrace) {
      _logError(
        'Error fetching stock by product ID: $productId',
        e,
        stackTrace,
      );
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get current stock for a product from the real-time data
  StokModel? getCurrentStockByProductId(int productId) {
    try {
      return _stocks.firstWhere((stock) => stock.produkId == productId);
    } catch (e) {
      // If not found, return null
      return null;
    }
  }

  // Get all stock mutations (history)
  Future<void> getStockMutations({int? limit}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stockMutations = await _stockService.getStockMutations(limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _logError('Error fetching stock mutations', e, stackTrace);
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get stock mutations by product ID
  Future<List<StokMutasiModel>> getStockMutationsByProductId(
    int productId,
  ) async {
    try {
      return await _stockService.getStockMutationsByProductId(productId);
    } catch (e, stackTrace) {
      _logError(
        'Error fetching stock mutations by product ID: $productId',
        e,
        stackTrace,
      );
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update stock quantity (private method - should only be used internally when needed)
  Future<StokModel> _updateStock(int productId, int newQuantity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedStock = await _stockService.updateStock(
        productId,
        newQuantity,
      );

      // Update the stock in the list
      final index = _stocks.indexWhere((s) => s.produkId == productId);
      if (index != -1) {
        _stocks[index] = updatedStock;
      } else {
        _stocks.add(updatedStock);
      }

      _isLoading = false;
      notifyListeners();
      return updatedStock;
    } catch (e, stackTrace) {
      _logError(
        'Error updating stock for product ID: $productId',
        e,
        stackTrace,
      );
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add stock mutation
  Future<StokMutasiModel> addStockMutation(StokMutasiModel mutation) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newMutation = await _stockService.addStockMutation(mutation);
      _stockMutations.insert(
        0,
        newMutation,
      ); // Add to the beginning of the list
      _isLoading = false;
      notifyListeners();
      return newMutation;
    } catch (e, stackTrace) {
      _logError('Error adding stock mutation', e, stackTrace);
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
