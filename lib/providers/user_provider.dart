import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_data.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserData>> {
  final SupabaseClient _supabaseClient;

  UserNotifier(this._supabaseClient) : super(const AsyncValue.loading());

  /// Fetches user details from Supabase and updates the state.
  Future<void> fetchUserDetails() async {
    try {
      // Get the currently authenticated user
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        state = const AsyncValue.error("No authenticated user found", StackTrace.empty);
        return;
      }

      // Fetch user details from the `users` table using the user's ID
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      // Convert the response into a UserData object
      final userData = UserData.fromJson(response);

      if (kDebugMode) {
        print("Successfully fetched user details from `users` table: ${userData.name}");
      }

      // Update the state with the fetched user
      state = AsyncValue.data(userData);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error fetching user details from `users` table: $e");
      }
      state = AsyncValue.error(e, stackTrace);
    }
  }


  /// Clears the current user data, typically used during logout.
  void clearUserData() {
    state = const AsyncValue.loading();
    if (kDebugMode) {
      print("User data cleared on logout.");
    }
  }

  /// A read-only getter for accessing the current user.
  UserData? get currentUser => state.asData?.value;
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserData>>((ref) {
  final supabaseClient = Supabase.instance.client;
  return UserNotifier(supabaseClient);
});
