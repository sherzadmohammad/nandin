import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  late final Dio dio;
  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://springgreen-porcupine-757961.hostingersite.com/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
  Future<Map<String, dynamic>> updateProfile(String name, String email, String mob1, String mob2, String address, String city) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) {
      return {
        'success': false,
        'message': 'Could not find token, please login again to fix the issue.',
      };
    }

    try {
      final response = await dio.post(
        'update-profile',
        data: {
          "name": name,
          "email": email,
          "mobile1": mob1,
          "mobile2": mob2,
          "address": address,
          "city": city,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {
          'success': true,
          'message': 'Profile updated successfully.',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update profile.',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] as String? ?? 'An error occurred',
      };
    }
  }
  Future<Map<String, dynamic>> updatePassword(String currentPassword, String newPassword) async {
    print('the currentPassword is : $currentPassword  and  the newPassword is : $newPassword');
    final prefs=await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null){
      return {
        'success': false,
        'message':  'could not find token please login again to fix the issue.',
      };
    }
    try {
      final response = await dio.post(
        'update-password',
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('the response data in the api services file is : ${response.data}');
      return response.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('an error occurred in api service file${e.error}');
      }
      return {
        'success': false,
        'message': e.response?.data['error'] ?? 'An error occurred',
      };
    }
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post('login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final role = response.data['role'] as String;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('role', role);
        return {
          'success': true,
          'token': token,
          'role': role,
        };
      }
      return {'success': false}; // Login failed
    } catch (e) {
      if (kDebugMode) {
        print("Login error: $e");
      }
      return {'success': false};
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('authToken');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('role');
  }
  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    try {
      final response = await dio.post('register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);

        return {'success': true, 'message': 'Registration successful!'};
      }

      return {'success': false, 'message': 'Registration failed'};
    } catch (e) {
      if (kDebugMode) {
        print("Registration error: $e");
      }
      return {'success': false, 'message': 'An error occurred'};
    }
  }
  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null){
    return null;
    }

    try {
      final response = await dio.get(
        'user-details',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (kDebugMode) {
          print("this is the user data after login in api service: ${response.data}");
        }
        return response.data['user'] as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user details: $e");
      }
      return null;
    }
  }
  Future<Map<String, dynamic>?> getCourseById(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) return null;

    try {
      final response = await dio.get(
        'course/$courseId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['course'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching course details: $e");
      }
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await dio.get('get-courses');

      if (response.statusCode == 200) {
        final List courses = response.data['courses'];
        return courses.map((course) => course as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching courses in api services : $e");
      }
      return [];
    }
  }
  Future<List<Map<String,dynamic>>> getTutors()async{
    try{
      final response=await dio.get("tutors");
      if(response.statusCode==200){
        return response.data as List<Map<String,dynamic>>;
      }
    }catch(e){
      if (kDebugMode) {
        print("Error fetching tutors in api service file:$e");
        return [];
      }
    }
      return [];
  }
  Future<Map<String, dynamic>?> getTutorDetailsById(int userId) async {
    try {
      final response = await dio.get('tutor/$userId');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user details by ID: $e");
      }
      return null;
    }
  }
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final token=prefs.getString('authToken');

    if (email != null && password != null&&token!=null) {

      final result = await login(email, password);
      return result['success'];
    }
    return false;
  }
  Future<List<Map<String, dynamic>>> getNotifications(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception("Token not found.");
    }

    try {
      final response = await dio.get(
        'get-notifications',
        data: {"type": type},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['notifications']);
      } else {
        throw Exception("Failed to load notifications in api services file");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching notifications in api services file : $e");
      }
      return [];
    }
  }
}
