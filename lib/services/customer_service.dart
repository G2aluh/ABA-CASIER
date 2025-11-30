import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/models/pelanggan_model.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';

class CustomerService {
  static final CustomerService _instance = CustomerService._internal();
  factory CustomerService() => _instance;
  CustomerService._internal();

  final SupabaseClient _supabase = SupabaseService().supabase;

  // Get all customers
  Future<List<PelangganModel>> getCustomers() async {
    try {
      final response = await _supabase.from('pelanggan').select();
      return response.map((data) => PelangganModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  // Add a new customer
  Future<PelangganModel> addCustomer(PelangganModel customer) async {
    try {
      final customerJson = customer.toJson();
      customerJson.remove(
        'pelangganid',
      ); // Remove ID so database can auto-generate it

      final response = await _supabase
          .from('pelanggan')
          .insert(customerJson)
          .select()
          .single();
      return PelangganModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add customer: $e');
    }
  }

  // Update a customer
  Future<PelangganModel> updateCustomer(PelangganModel customer) async {
    try {
      final customerJson = customer.toJson();
      customerJson.remove('pelangganid'); // Remove ID from update data

      final response = await _supabase
          .from('pelanggan')
          .update(customerJson)
          .eq('pelangganid', customer.pelangganId!)
          .select()
          .single();

      return PelangganModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  // Delete a customer
  Future<void> deleteCustomer(int customerId) async {
    try {
      await _supabase.from('pelanggan').delete().eq('pelangganid', customerId);
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }

  // Get customer by ID
  Future<PelangganModel?> getCustomer(int customerId) async {
    try {
      final response = await _supabase
          .from('pelanggan')
          .select()
          .eq('pelangganid', customerId)
          .single();
      return PelangganModel.fromJson(response);
    } catch (e) {
      print('Failed to fetch customer: $e');
      return null;
    }
  }

  // Get real-time customer stream
  Stream<List<Map<String, dynamic>>> getCustomerStream() {
    return _supabase.from('pelanggan').stream(primaryKey: ['pelangganid']);
  }
}
