import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

enum RequestType { GET, POST, DELETE, PUT }

class RequestTypeNotFoundException implements Exception {
  String cause;
  RequestTypeNotFoundException(this.cause);
}

class Nothing {
  Nothing._();
}

class EmployeeServiceClient {
  // 1
  static const String _baseUrl =
      "http://dummy.restapiexample.com/api/v1";
  final Client _client;
  EmployeeServiceClient(this._client);
  Future<Response> request(
      {@required RequestType requestType,
      @required String path,
      dynamic parameter = Nothing}) async {
    switch (requestType) {
      case RequestType.GET:
        return _client.get("$_baseUrl/$path");
      case RequestType.POST:
        return _client.post("$_baseUrl/$path",
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));
      case RequestType.PUT:
        return _client.put("$_baseUrl/$path",
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));
      case RequestType.DELETE:
        return _client.delete("$_baseUrl/$path");
      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request method is not found");
    }
  }
}

class Result<T> {
  Result._();

  factory Result.loading(T msg) = LoadingState<T>;

  factory Result.success(T value) = SuccessState<T>;

  factory Result.error(T msg) = ErrorState<T>;
}

class LoadingState<T> extends Result<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends Result<T> {
  SuccessState(this.value) : super._();
  final T value;
}

