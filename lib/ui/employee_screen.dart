import 'package:postsampleapp/services/employee_response.dart';
import 'package:postsampleapp/services/employee_service_client.dart';
import 'package:postsampleapp/services/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:postsampleapp/ui/employee_detail_screen.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employees"),
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Employee',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employee: new Employee(name: '', salary: '', age:''))));
          },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: _apiResponse.getEmployees(),
            builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
              if (snapshot.data is SuccessState) {
                EmployeeResponse response = (snapshot.data as SuccessState).value;
                return ListView.builder(
                    itemCount: response.data.length,
                    itemBuilder: (context, index) {
                      return new ListTile(
                        title: Text(response.data[index].name),
                        subtitle: Text('Salary: ' + response.data[index].salary + ' Age: ' + response.data[index].age),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => onTapped((response.data[index])),
                      );
                    });
              } else if (snapshot.data is ErrorState) {
                String errorMessage = (snapshot.data as ErrorState).msg;
                return Text(errorMessage);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  void onTapped(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employee: employee)),
    );
  }
}

