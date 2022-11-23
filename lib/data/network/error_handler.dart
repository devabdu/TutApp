import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = _handleError(error);
    } else {
      failure = DataSource.unKnown.getFailure();
    }
  }
}

Failure _handleError(DioError error) {
  switch (error.type) {
    case DioErrorType.connectTimeout:
      return DataSource.connectTimeOut.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.sendTimeOut.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.receiveTimeOut.getFailure();
    case DioErrorType.response:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(error.response?.statusCode ?? 0,
            error.response?.statusMessage ?? "");
      } else {
        return DataSource.unKnown.getFailure();
      }
    case DioErrorType.cancel:
      return DataSource.cancel.getFailure();
    case DioErrorType.other:
      return DataSource.unKnown.getFailure();
  }
}

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unAuthorized,
  notFound,
  internalServerError,
  connectTimeOut,
  cancel,
  receiveTimeOut,
  sendTimeOut,
  cacheError,
  noInternetConnection,
  unKnown
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success.tr());
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent.tr());
      case DataSource.badRequest:
        return Failure(
            ResponseCode.badRequest, ResponseMessage.badRequest.tr());
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden.tr());
      case DataSource.unAuthorized:
        return Failure(
            ResponseCode.unAuthorized, ResponseMessage.unAuthorized.tr());
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound.tr());
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError.tr());
      case DataSource.connectTimeOut:
        return Failure(
            ResponseCode.connectTimeOut, ResponseMessage.connectTimeOut.tr());
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel.tr());
      case DataSource.receiveTimeOut:
        return Failure(
            ResponseCode.receiveTimeOut, ResponseMessage.receiveTimeOut.tr());
      case DataSource.sendTimeOut:
        return Failure(
            ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut.tr());
      case DataSource.cacheError:
        return Failure(
            ResponseCode.cacheError, ResponseMessage.cacheError.tr());
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection.tr());
      case DataSource.unKnown:
        return Failure(ResponseCode.unKnown, ResponseMessage.unKnown.tr());
    }
  }
}

class ResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unAuthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;

  ///local status code
  static const int connectTimeOut = -1;
  static const int cancel = -2;
  static const int receiveTimeOut = -3;
  static const int sendTimeOut = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int unKnown = -7;
}

class ResponseMessage {
  static const String success = AppStrings.success;
  static const String noContent = AppStrings.noContent;
  static const String badRequest = AppStrings.badRequest;
  static const String unAuthorized = AppStrings.unAuthorized;
  static const String forbidden = AppStrings.forbidden;
  static const String notFound = AppStrings.notFound;
  static const String internalServerError = AppStrings.internalServerError;

  //local status code
  static const String connectTimeOut = AppStrings.connectTimeOut;
  static const String cancel = AppStrings.cancel;
  static const String receiveTimeOut = AppStrings.receiveTimeOut;
  static const String sendTimeOut = AppStrings.sendTimeOut;
  static const String cacheError = AppStrings.cacheError;
  static const String noInternetConnection = AppStrings.noInternetConnection;
  static const String unKnown = AppStrings.unKnown;
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
