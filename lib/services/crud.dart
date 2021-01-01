import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DatabaseService{
  var uuid = Uuid();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  final employeesReference = FirebaseDatabase.instance.reference().child('bakery').child('employees');

  void addEmployee(Map data){
    var v1 = uuid.v1();
    employeesReference.child(v1).set(data);
  }

  void updateEmployee(String uid,Map data){
    employeesReference.child(uid).update(data);
  }

  void deleteEmployee(String uid){
    employeesReference.child(uid).remove();
  }
}