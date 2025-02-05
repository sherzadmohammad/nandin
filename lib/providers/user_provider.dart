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
    // Fetch the current authenticated user
    final userResponse = await _supabaseClient.auth.getUser();

    // Access the user object and its metadata
    final user = userResponse.user;
    final rawUserData = user?.userMetadata;

    if (rawUserData != null) {
      // Parse the response into a User object
      if (kDebugMode) {
        print("Successfully returned user details from Supabase: ${rawUserData['name']}");
      }
      final userData = UserData.fromJson(rawUserData);

      if (kDebugMode) {
        print("Successfully fetched user details from Supabase: ${userData.name}");
      }

      // Update the state with the fetched user
      state = AsyncValue.data(userData);
    } else {
      if (kDebugMode) {
        print("No user metadata available in user-provider file.");
      }
      state = const AsyncValue.error("User metadata not found",StackTrace.empty);
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print("Error fetching user details from Supabase: $e");
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
