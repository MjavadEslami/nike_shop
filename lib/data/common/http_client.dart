import 'package:dio/dio.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';

final httClient = Dio(BaseOptions(
  baseUrl: 'http://expertdevelopers.ir/api/v1/',
))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
      }
      handler.next(options);
    },
  ));
