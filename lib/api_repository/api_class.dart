import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:sparkd/api_repository/loading.dart';
import 'package:sparkd/core/constants/constants.dart';
import 'package:sparkd/core/constants/helper.dart';

class HttpUtil {
  // Body params name ->
  static String name = "name";
  static String email = "email";
  static String password = "password";
  static String authProvider = "auth_provider";
  static String gender = "gender";
  static String age = "age";
  static String personalityType = "personality_type";
  static String profileImageUrl = "profile_image_url";
  static String otp = "otp";
  static String pin = "pin";
  static String newPin = "newPin";
  static String oldPin = "oldPin";
  static String deviceId = "device_id";
  static String isForgetPin = "isForgetPin";
  static String conversationId = "conversation_id";
  static String isArchive = "isArchive";
  static String message = "message";
  static String objective = "objective";
  static String content = "content";
  static String userId = "user_id";
  static String fileData = "file_data";
  static String skip = "skip";
  static String size = "size";
  static String filePath = "filePath";
  static String messageId = "message_id";
  static String isManually = "is_manually";
  static String isSparkDLine = "is_sparkd_line";
  static const String previousSuggestions = "previous_suggestions";

  factory HttpUtil(String token, bool isLoading, BuildContext context) =>
      _instance(token, isLoading, context);

  static HttpUtil _instance(token, isLoading, context) =>
      HttpUtil._internal(token: token, isLoading: isLoading, context: context);

  late Dio dio;
  CancelToken cancelToken = CancelToken();
  String apiUrl = Constants.baseUrl;

  BuildContext? context;

  HttpUtil._internal(
      {String? token, bool? isLoading, required BuildContext context}) {
    if (utils.isValidationEmpty(token)) {
      token = getStorageData.readString(getStorageData.tokenKey);
    }
    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: Duration(minutes: 1),
      receiveTimeout: Duration(minutes: 1),
      headers: {
        'Authorization': "Bearer $token",
      },
      responseType: ResponseType.json,
    );

    dio = Dio(options);
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isLoading!) {
          Loading.show();
        }
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        if (isLoading!) {
          Loading.dismiss();
        }

        return handler.next(response); // continue
      },
      onError: (DioError e, handler) async {
        Loading.dismiss();

        return handler.resolve(e.response!);
      },
    ));
  }

// On Error....
  void onError(ErrorEntity eInfo, BuildContext context) {
    printError(
        "error.code -> ${eInfo.code}, error.message -> ${eInfo.message}");
    if (eInfo.message.isNotEmpty) {
      utils.showToast(message: eInfo.message);
    }
  }

  createErrorEntity(DioError error) {
    Loading.dismiss();

    switch (error.type) {

      case DioErrorType.badResponse:
        {
          try {
            int errCode =
                error.response != null ? error.response!.statusCode! : 00;
            switch (errCode) {
       
              case 401:
                errorEntity(code: errCode, message: "Permission denied");
                break;
              
              default:
                utils.showToast(message: error.response!.data['message']);
            
            }
          } on Exception catch (_) {
            errorEntity(code: 0, message: "Unknown mistake");
          }
        }
        break;
      case DioErrorType.unknown:
        if (error.message!.contains("SocketException")) {
          errorEntity(
              code: -5,
              message:
                  "Your internet is not available, please try again later");
        } else if (error.message!
            .contains("Software caused connection abort")) {
          errorEntity(
              code: -6,
              message:
                  "Your internet is not available, please try again later");
        }
        errorEntity(code: -7, message: "Oops something went wrong");
        break;
      default:
        errorEntity(code: -8, message: "Oops something went wrong");
        break;
    }
  }

  void cancelRequests() {
    cancelToken.cancel("cancelled");
  }

  /// restful get
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = true,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ??
        Options(
          receiveTimeout: Duration(minutes: 10),
          // headers: Constants.headers,
          // contentType: 'application/json; charset=utf-8',
          responseType: ResponseType.json,
        );
    ;
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });

    var response = await dio.get(
      path,

    );
    return response;
  }

  /// restful post
  Future post(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ??
        Options(
          receiveTimeout: Duration(minutes: 10),
        
          responseType: ResponseType.json,
        );

    var response = await dio.post(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful put
  Future put(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.put(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful delete
  Future delete(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful patch
  Future patch(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.patch(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post form
  Future postForm(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post Stream
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}

void errorEntity({
  required code,
  required message,
}) {
  if (!utils.isValidationEmpty(message)) {
    printAction("test_message: $message");
    utils.showToast(message: message);
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    printAction("test_message: $message");

    if (!utils.isValidationEmpty(message)) {
      printAction("test_message: $message");
      utils.showToast(message: message);
    }

    if (message == "") {
      return "Exception";
    } else {
      return "Exception: code $code, $message";
    }
  }
}
