import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
//untuk cek kondisi ada auth atau tidak dari uid
// Null -> tidak ada user yang sedang login

  String? uid;
  late FirebaseAuth auth;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return {
        "error": false,
        "message": "Berhasil Login",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "error": true,
        "message": "Gagal Login karena ${e.message}",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal Login karena $e",
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await auth.signOut();
      return {
        "error": false,
        "message": "Berhasil Logout",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "error": true,
        "message": "Gagal Logout karena ${e.message}",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Gagal Logout karena $e",
      };
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });
    super.onInit();
  }
}
