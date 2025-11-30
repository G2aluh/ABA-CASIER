import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/pelanggan_model.dart';
import 'package:simulasi_ukk/services/customer_service.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  bool _isLoading = false;
  String? _errorMessage;
  List<PelangganModel> _customers = [];

  // Stream for real-time updates
  late Stream<List<PelangganModel>> _customersStream;

  // Getter for the customers stream
  Stream<List<PelangganModel>> get customersStream => _customersStream;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PelangganModel> get customers => _customers;

  CustomerProvider() {
    // Initialize the stream when the provider is created
    _initStream();
  }

  // Initialize the real-time stream
  void _initStream() {
    _customersStream = _customerService.getCustomerStream().map(
      (list) => list.map((data) => PelangganModel.fromJson(data)).toList(),
    );
  }

  // Get all customers
  Future<void> getCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _customers = await _customerService.getCustomers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add a new customer
  Future<void> addCustomer(PelangganModel customer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCustomer = await _customerService.addCustomer(customer);
      _customers.add(newCustomer);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update a customer
  Future<void> updateCustomer(PelangganModel customer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCustomer = await _customerService.updateCustomer(customer);
      // Find and replace the customer in the list
      final index = _customers.indexWhere(
        (c) => c.pelangganId == customer.pelangganId,
      );
      if (index != -1) {
        _customers[index] = updatedCustomer;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete a customer
  Future<void> deleteCustomer(int customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _customerService.deleteCustomer(customerId);
      _customers.removeWhere((customer) => customer.pelangganId == customerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
