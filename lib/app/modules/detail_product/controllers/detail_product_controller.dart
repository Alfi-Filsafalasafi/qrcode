import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  //TODO: Implement DetailProductController
  RxBool isLoading = false.obs;
  RxBool isLoadingDelete = false.obs;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      var hasil =
          await firebase.collection("products").doc(data["uid"]).update({
        "name": data["name"],
        "qty": data["qty"],
      });
      return {
        "error": false,
        "message": "Berhasil mengupdate data",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal mengupdate data",
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String uid) async {
    try {
      await firebase.collection("products").doc(uid).delete();

      return {
        "error": false,
        "message": "Berhasil menghapus data",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal menghapus data",
      };
    }
  }
}
