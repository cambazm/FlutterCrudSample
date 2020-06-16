import 'dart:convert';

class EmployeeResponse {
  final String status;
  final List<Employee> data;

  EmployeeResponse({this.status, this.data});

  factory EmployeeResponse.fromRawJson(String str) =>
      EmployeeResponse.fromJson(json.decode(str));

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) => EmployeeResponse(
      status: json['status'],
      data: List<Employee>.from(
          json["data"].map((x) => Employee.fromJson(x))));
}

class Employee {
  final String name;
  final String id;
  final String salary;
  final String age;

  Employee({this.name, this.id, this.salary, this.age});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['employee_name'] as String,
      id: json['id'] as String,
      salary: json['employee_salary'] as String,
      age: json['employee_age'] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "salary": salary, "age": age};
}



class DeleteResponse {
  String status;
  String message;

  DeleteResponse({this.status, this.message});

  factory DeleteResponse.fromRawJson(String str) =>
      DeleteResponse.fromJson(json.decode(str));

  DeleteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}


class AddOrUpdateResponse {
  String status;
  Data data;

  AddOrUpdateResponse({this.status, this.data});

  factory AddOrUpdateResponse.fromRawJson(String str) =>
      AddOrUpdateResponse.fromJson(json.decode(str));

  AddOrUpdateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String name;
  String salary;
  String age;
  int id;

  Data({this.name, this.salary, this.age, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    salary = json['salary'];
    age = json['age'];
    id = json['id'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['salary'] = this.salary;
    data['age'] = this.age;
    data['id'] = this.id;
    return data;
  }
}