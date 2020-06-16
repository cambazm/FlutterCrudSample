import 'dart:async';
import 'package:http/http.dart';
import 'network_response.dart';
import 'employee_service_client.dart';
import 'employee_response.dart';

class RemoteDataSource {
  //Creating Singleton
  RemoteDataSource._privateConstructor();

  static final RemoteDataSource _apiResponse =
  RemoteDataSource._privateConstructor();

  factory RemoteDataSource() => _apiResponse;

  static const int timeoutConfig = 2;

  StreamController<Result> _addEmployeeStream;
  Stream<Result> hasEmployeeAdded() => _addEmployeeStream.stream;

  StreamController<Result> _editEmployeeStream;
  Stream<Result> hasEmployeeEdited() => _editEmployeeStream.stream;

  void init() {
    _addEmployeeStream = StreamController();
    _editEmployeeStream = StreamController();
  }

  EmployeeServiceClient client = EmployeeServiceClient(Client());

  Future<Result> getEmployees() async {
    try {
      final response =
      await client.request(requestType: RequestType.GET, path: "employees");
      if (response.statusCode == 200) {
        EmployeeResponse r = EmployeeResponse.fromRawJson(response.body);
        return Result<EmployeeResponse>.success(r);
      } else {
        return Result.error("Cannot found");
      }
    } catch (error) {
      return Result.error("Error on service!");
    }
  }

  Future<Result> addEmployee(Employee employee) async {
    _addEmployeeStream.sink.add(Result<String>.loading("Loading"));
    try {
      final response = await client.request(
          requestType: RequestType.POST, path: "create", parameter: employee)
          .timeout(const Duration(seconds: timeoutConfig));
      if (response.statusCode == 200) {
        //print(response.body);
        _addEmployeeStream.sink.add(Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body)));
        AddOrUpdateResponse r = AddOrUpdateResponse.fromRawJson(response.body);
        return Result<AddOrUpdateResponse>.success(r);
      } else {
        _addEmployeeStream.sink.add(Result.error("Something went wrong on adding"));
      }
    } catch (error) {
      _addEmployeeStream.sink.add(Result.error("Something went wrong!"));
    }
  }

  Future<Result> editEmployee(Employee employee) async {
    _editEmployeeStream.sink.add(Result<String>.loading("Loading"));
    try {
      final response = await client.request(
          requestType: RequestType.PUT,
          path: "update/" + employee.id,
          parameter: employee).timeout(const Duration(seconds: timeoutConfig));
      if (response.statusCode == 200) {
        //print(response.body);
        _editEmployeeStream.sink.add(Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body)));
        AddOrUpdateResponse r = AddOrUpdateResponse.fromRawJson(response.body);
        return Result<AddOrUpdateResponse>.success(r);
      } else {
        _editEmployeeStream.sink.add(
            Result.error("Something went wrong on editing"));
      }
    } catch (error) {
      _editEmployeeStream.sink.add(Result.error("Something went wrong!"));
    }
  }

  Future<Result> deleteEmployee(Employee employee) async {
    try {
      final response = await client.request(
          requestType: RequestType.DELETE, path: "delete/" + employee.id)
          .timeout(const Duration(seconds: timeoutConfig));
      if (response.statusCode == 200) {
        //print(response.body);
        return Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body));
        //DeleteResponse r = DeleteResponse.fromRawJson(response.body);
        //return Result<DeleteResponse>.success(r);
      } else {
        return Result<NetworkResponse>.error(
            NetworkResponse.fromRawJson(response.body));
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }

  void dispose() {
    _addEmployeeStream.close();
    _editEmployeeStream.close();
  }
}
