
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
