import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      var productBaru = await firebase.collection("products").add(data);
      await firebase.collection("products").doc(productBaru.id).update({
        "productID": productBaru.id,
      });
      return {
        "error": false,
        "message": "Berhasil menambah data",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal menambah data karena $e",
      };
    }
  }
}
