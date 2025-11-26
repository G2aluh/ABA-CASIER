import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';
import 'package:simulasi_ukk/models/user_model.dart';

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
}
