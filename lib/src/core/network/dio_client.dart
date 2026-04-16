import 'dart:async';
import 'package:dio/dio.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;

  Future<bool> Function()? onRefreshToken;

  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  DioClient({required this.storage}) : dio = Dio() {
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
          final is401 = e.response?.statusCode == 401;
          final isRetry = e.requestOptions.extra['_retry'] == true;

          if (is401 && !isRetry && onRefreshToken != null) {
            try {
              final refreshed = await _handleRefresh();

              if (refreshed) {
                final newToken = await storage.getToken();

                final opts = e.requestOptions
                  ..headers['Authorization'] = 'Bearer $newToken'
                  ..extra['_retry'] = true;

                final response = await dio.fetch(opts);
                return handler.resolve(response);
              }
            } catch (_) {
              // refresh failed
            }
          }

          await storage.clear();
          handler.next(e);
        },
      ),
    );
  }

  Future<bool> _handleRefresh() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final result = await onRefreshToken!.call();

      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
}
