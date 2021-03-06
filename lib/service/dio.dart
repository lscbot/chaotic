part of services;

class DioService {
  DioService._();

  static final _instance = DioService._();
  void Function()? onUnauthenticated;
  void Function(String errorDescription, Exception e)? onRegularError;

  factory DioService.getInstance() => _instance;

  //--------------------
  final _dio = Dio();
  bool debugMode = false;

  set options(BaseOptions baseOptions) => _dio.options = baseOptions;

  void addHeader(Map<String, String> header) =>
      _dio.options.headers.addAll(header);

  void removeHeader(String header) => _dio.options.headers.remove(header);

  void initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (debugMode) {
            log('*' * 10);
            log(options.data.toString());
            log(options.headers.toString());
            log('${options.method} ${options.path}');
          }
          options.data = FormData.fromMap(options.data as Map<String, dynamic>);
          // Do something before request is sent
          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          if (debugMode) {
            log(response.data.toString());
            log('${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
            log('*' * 10);
          }
          // Do something with response data
          return handler.next(response); // continue
        },
        onError: (DioError e, handler) {
          if (debugMode) {
            log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            log('*' * 10);
          }
          // Do something with response error
          return handler.next(e); //continue
        },
      ),
    );
  }

  Future<Result<T>> get<T>(
    String api, {
    Map<String, dynamic>? queryParameters,
    String? parameter,
    bool showLoading = false,
    bool unAuthDialog = true,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.get<T>(
        parameter == null ? api : '$api/$parameter',
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception, unAuthDialog);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> post<T>(
    String api, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool showLoading = false,
    bool unAuthDialog = true,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.post<T>(
        api,
        data: data,
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception, unAuthDialog);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> put<T>(
    String api, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? parameter,
    bool showLoading = false,
    bool unAuthDialog = true,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.put<T>(
        parameter == null ? api : '$api/$parameter',
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception, unAuthDialog);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> delete<T>(
    String api, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? parameter,
    bool showLoading = false,
    bool unAuthDialog = true,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.delete<T>(
        parameter == null ? api : '$api/$parameter',
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception, unAuthDialog);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void getErrorMessage(Exception error, bool unAuth) {
    String errorDescription = '';
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = 'Request to API server was cancelled';
          break;
        case DioErrorType.connectTimeout:
          errorDescription = 'Connection timeout with API server';
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = 'Receive timeout in connection with API server';
          break;
        case DioErrorType.sendTimeout:
          errorDescription = 'Send timeout with server';
          break;
        case DioErrorType.response:
          final errorResponseCodes = [404, 500, 503];
          if (errorResponseCodes.contains(error.response!.statusCode)) {
            errorDescription = error.response?.statusMessage ?? '';
          } else {
            final dioError = error;
            if (dioError is DioError) {
              if (dioError.response?.statusCode == 401 && unAuth) {
                onUnauthenticated?.call();
              }
              errorDescription =
                  dioError.response?.data['message'].toString() ?? '';
              log(dioError.response?.data.toString() ?? '');
            } else {
              errorDescription =
                  'Failed to load data - status code: ${error.response!.statusCode}';
            }
          }
          break;
        case DioErrorType.other:
          errorDescription = error.toString();
          break;
      }
    } else {
      errorDescription = 'Unexpected error occurred ${error.toString()}';
    }
    onRegularError?.call(errorDescription, error);
    if (debugMode) log(errorDescription);
  }
}

class Result<T> {
  final Response<T>? response;
  final Exception? error;

  Result({this.response, this.error});
}
