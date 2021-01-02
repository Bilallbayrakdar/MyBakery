import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_my_bakery/models/Category.dart';
import 'package:flutter_my_bakery/models/Market.dart';
import 'package:flutter_my_bakery/models/Payer.dart';
import 'package:flutter_my_bakery/models/Worker.dart';
import 'package:flutter_my_bakery/models/Product.dart';

class DatabaseService {
  final marketsReference =
      FirebaseDatabase.instance.reference().child('bakery').child('markets');
  final workersReference =
      FirebaseDatabase.instance.reference().child('bakery').child('employees');
  final payersReference =
      FirebaseDatabase.instance.reference().child('bakery').child('payers');
  final categoryReference =
      FirebaseDatabase.instance.reference().child('bakery').child('categories');

  void addMarket(Market market) {
    marketsReference.child(market.name).set(market.toMap());
  }

  void deleteMarket(String marketName) {
    marketsReference.child(marketName).remove();
  }

  void addWorker(Worker worker) {
    workersReference.child(worker.name).set(worker.toMap());
  }

  void deleteWorker(String workerName) {
    workersReference.child(workerName).remove();
  }

  void updateWorker(String workerName, Worker worker) {
    workersReference.child(workerName).update(worker.toMap());
  }

  void addPayer(Payer payer) {
    payersReference.child(payer.name).set(payer.toMap());
  }

  void addCategory(Category category){
    categoryReference.child(category.name).set(category.toMap());
  }

  void deletePayer(String payerName) {
    payersReference.child(payerName).remove();
  }

  void deleteProduct(Product product) {
    categoryReference.child(product.category).child(product.name).remove();
  }

  void deleteProduct2(String categoryName,String productName) {
    categoryReference.child(categoryName).child(productName).remove();
  }

  void deleteCategory(String categoryName){
    categoryReference.child(categoryName).remove();
  }

  void updateCategory(String categoryName,Category category) {
    workersReference.child(categoryName).update(category.toMap());
  }

  void addProduct(Product product) {
    categoryReference
        .child(product.category)
        .child(product.name)
        .set(product.toMap());
  }

  void updateProduct(String uid,Product product) {
    categoryReference
        .child(product.category)
        .child(uid)
        .update(product.toMap());
  }
}
