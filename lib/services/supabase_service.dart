import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient supabase;

  Future<void> initialize() async {
    try {

      final supabaseInstance = await Supabase.initialize(
        url: 'https://uzlqquvufdmpndlrzvfc.supabase.co', 
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6bHFxdXZ1ZmRtcG5kbHJ6dmZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcwOTM1MjksImV4cCI6MjA1MjY2OTUyOX0.Cnk2T5UuzopCfbtcQAm4x7S7NKPYqleiZM7La8MNaac', 
      );
      supabase = supabaseInstance.client;
    } catch (e) {
      print('Supabase initialization error: $e');
      rethrow;
    }
  }
}
