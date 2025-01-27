import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_data.dart';
import '../services/api_services.dart';
import 'api_service_provider.dart';

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  final ApiService _apiService;
  UserNotifier(this._apiService) : super(const AsyncValue.loading());
  Future<void> fetchUserDetails() async {
    try {
      final userDetails = await _apiService.getUserDetails();
      if (userDetails == null) {
        if (kDebugMode) {
          print("Error fetching user details in the user provider file");
        }
        return;
      }
      final user = User.fromJson(userDetails);
      if (kDebugMode) {
        print("successfully fetch user details in user provider: ${user.name}");
      }
      state =AsyncValue.data(user);

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error fetching user details in the user provider file: $e");
      }
      state = AsyncValue.error(e, stackTrace);
    }
  }
  AsyncData<User>? get userData => state.asData;
  void clearUserData() {
    state = const AsyncValue.loading();
    if (kDebugMode) {
      print("User data cleared on logout");
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserNotifier(apiService);
});
