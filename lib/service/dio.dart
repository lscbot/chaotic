part of services;

class DioService {
  DioService._();

  static final _instance = DioService._();

  factory DioService.getInstance() => _instance;

  //--------------------
  final _dio = Dio();
  bool debugMode = false;

  set options(BaseOptions baseOptions) => _dio.options = baseOptions;

  void addHeader(Map<String, String> header) =>
      _dio.options.headers.addAll(header);

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
    String uri, {
    Map<String, dynamic>? queryParameters,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.get<T>(
        uri,
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> post<T>(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.post<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> put<T>(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.put<T>(
        uri,
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<Result<T>> delete<T>(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) BotToast.showLoading();
      final response = await _dio.delete<T>(
        uri,
        data: FormData.fromMap(data ?? {}),
        queryParameters: queryParameters,
      );
      return Result(response: response);
    } catch (e) {
      getErrorMessage(e as Exception);
      return Result(error: e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void getErrorMessage(Exception error) {
    String errorDescription = '';
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = 'Request to API server was cancelled';
          break;
        case DioErrorType.connectTimeout:
          errorDescription = 'Connection timeout with API server';
          break;
        case DioErrorType.other:
          errorDescription =
              'Connection to API server failed due to internet connection';
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
              errorDescription =
                  dioError.response?.data['message'].toString() ?? '';
              log(dioError.response?.data.toString() ?? '');
            } else {
              errorDescription =
                  'Failed to load data - status code: ${error.response!.statusCode}';
            }
          }
          break;
      }
    } else {
      errorDescription = 'Unexpected error occurred ${error.toString()}';
    }
    BotToast.showSimpleNotification(
      title: tr('notification.titleError'),
      subTitle: errorDescription,
    );
    if (debugMode) log(errorDescription);
  }
}

class Result<T> {
  final Response<T>? response;
  final Exception? error;

  Result({this.response, this.error});
}
