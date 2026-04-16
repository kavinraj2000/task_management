import 'package:dio/dio.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;
  final void Function()? onLogout;

  Future<bool> Function()? onRefreshToken;

  DioClient({required this.storage, this.onLogout}) : dio = Dio() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onError: (DioException e, handler) async {
          final is401     = e.response?.statusCode == 401;
          final isRetry   = e.requestOptions.extra['_retry'] == true;

          if (is401 && !isRetry && onRefreshToken != null) {
            final refreshed = await onRefreshToken!();

            if (refreshed) {
              final newToken = await storage.getToken();
              final opts = e.requestOptions
                ..headers['Authorization'] = 'Bearer $newToken'
                ..extra['_retry'] = true;          

              try {
                final retryResp = await dio.fetch(opts);
                return handler.resolve(retryResp);
              } catch (retryErr) {
                return handler.next(e);
              }
            }
          }

          await storage.clear();
          onLogout?.call();
          handler.next(e);
        },
      ),
    );
  }
}