import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = SupabaseService().supabase;

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    String? role,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nama': name, 'role': role ?? 'pegawai'},
      );

      if (response.user != null) {
        await _supabase
            .from('users')
            .update({'nama': name, 'role': role ?? 'pegawai'})
            .eq('id', response.user!.id);
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // User login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // User logout
  Future<void> logout() async {
    try {
      // Check if there's an active session before trying to sign out
      if (_supabase.auth.currentSession != null) {
        await _supabase.auth.signOut();
      }
      // If there's no session (anonymous user), we still want to clear any local state
    } catch (e) {
      // Check if the error is related to no session being active
      if (e.toString().contains('session') ||
          e.toString().contains('No active')) {
        // This is expected for anonymous users, so we don't throw an error
        print('No active session to sign out from (likely anonymous user)');
      } else {
        print('Logout error: $e');
        // Don't rethrow the exception, just log it
      }
    }
  }

  // Get user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Cek jika sudah terautentikasi
  bool isAuthenticated() {
    return _supabase.auth.currentSession != null;
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Failed to fetch user details: $e');
      return null;
    }
  }
}
