import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamProduct() async* {
    yield* firebase.collection("products").snapshots();
  }
}
