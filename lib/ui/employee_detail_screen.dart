import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:postsampleapp/services/employee_response.dart';
import 'package:postsampleapp/services/network_response.dart';
import 'package:postsampleapp/services/remote_data_source.dart';
import 'package:postsampleapp/services/employee_service_client.dart';
import 'package:flushbar/flushbar.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;
  EmployeeDetailScreen({this.employee});

  @override
  EmployeeDetailScreenState createState() {
    return EmployeeDetailScreenState();
  }
}

class EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  var data;
  bool autoValidate = false;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
  GlobalKey<FormFieldState>();
  String _name, _age, _salary;
  ProgressDialog progressDialog = null;

  //ValueChanged _onChanged = (val) => print(val);

  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  void initState() {
    super.initState();
    _apiResponse.init();
    hasEmployeeAddedListener();
    hasEmployeeEditedListener();
    progressDialog = ProgressDialog(context);
  }

  bool isEdit() {
    return widget.employee.id != null;
  }

  void hasEmployeeAddedListener() {
    _apiResponse.hasEmployeeAdded().listen((Result result) {
      if (result is LoadingState) {
        progressDialog.show();
      } else if (result is SuccessState) {
        progressDialog.hide();
        Navigator.pop(context); //navigate back
      } else {
        progressDialog.hide();
        Flushbar(
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          leftBarIndicatorColor: Colors.red[300],
          backgroundColor: Colors.red,
          boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
          titleText: Text("Add Error", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black, fontFamily:"ShadowsIntoLightTwo"),),
          messageText: Text("Was not able to add", style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),),
          duration:  Duration(seconds: 3),
        )..show(context);
      }
    });
  }

  void hasEmployeeEditedListener() {
    _apiResponse.hasEmployeeEdited().listen((Result result) {
      if (result is LoadingState) {
        progressDialog.show();
      } else if (result is SuccessState) {
        progressDialog.hide();
        Navigator.pop(context); //navigate back
      } else {
        progressDialog.hide();
        Flushbar(
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          leftBarIndicatorColor: Colors.red[300],
          backgroundColor: Colors.red,
          boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
          titleText: Text("Edit Error", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black, fontFamily:"ShadowsIntoLightTwo"),),
          messageText: Text("Was not able to edit", style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),),
          duration:  Duration(seconds: 3),
        )..show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Input"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              autovalidate: autoValidate,
              readOnly: readOnly,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    initialValue: isEdit() ? widget.employee.name : '',
                    attribute: "name",
                    decoration: InputDecoration(
                      labelText: "Employee Name",
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    initialValue: isEdit() ? widget.employee.salary : '',
                    attribute: "salary",
                    decoration: InputDecoration(
                      labelText: "Salary",
                    ),
                    onChanged: (value) {
                      _salary = value;
                    },
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    initialValue: isEdit() ? widget.employee.age : '',
                    attribute: "age",
                    decoration: InputDecoration(
                      labelText: "Age",
                    ),
                    onChanged: (value) {
                      _age = value;
                    },
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(100),
                      FormBuilderValidators.min(18),
                    ],
                    keyboardType: TextInputType.number,
                  ),

                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: isEdit() ? new Text(
                      "Edit",
                      style: TextStyle(color: Colors.black),
                    ) :
                    new Text(
                      "Add",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        if(isEdit()) {
                          _apiResponse.editEmployee(new Employee(
                              id: widget.employee.id, name: _name, age: _age, salary: _salary))
                              .then((value) {
                            //print((value as AddOrUpdateResponse).status);
                            /*Flushbar(
                              titleText: Text("Response"),
                              messageText: Text((value as AddOrUpdateResponse).status),
                              duration:  Duration(seconds: 2),
                            )..show(context);*/
                          }
                          );
                        }
                        else {
                           _apiResponse.addEmployee(new Employee(
                              name: _name, age: _age, salary: _salary))
                               .then((value) {
                                 //print((value as AddOrUpdateResponse).status);
                                 /*Flushbar(
                                   titleText: Text("Response"),
                                   messageText: Text((value as AddOrUpdateResponse).status),
                                   duration:  Duration(seconds: 2),
                                 )..show(context);*/
                               }
                            );
                        }
                          //print(_fbKey.currentState.value);
                      } else {
                          //print(_fbKey.currentState.value);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Visibility(
                    visible: isEdit(),
                    child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                        _apiResponse.deleteEmployee(new Employee(
                            id: widget.employee.id,
                            name: widget.employee.name,
                            age: widget.employee.age,
                            salary: widget.employee.salary))
                            .then((value) {
                          /*Flushbar(
                            titleText: Text("Response"),
                            messageText: Text((value as NetworkResponse).message),
                            duration:  Duration(seconds: 2),
                          )..show(context);*/
                        }
                        );
                    },
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}