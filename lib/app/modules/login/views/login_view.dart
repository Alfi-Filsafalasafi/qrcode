import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/auth_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passwordC =
      TextEditingController(text: "admin12345");

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LoginView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => TextField(
                controller: passwordC,
                obscureText: controller.isHidden.value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text("Password"),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isHidden.toggle();
                        },
                        icon: Icon(controller.isHidden.isFalse
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> hasil =
                        await authC.login(emailC.text, passwordC.text);
                    if (hasil["error"] == true) {
                      Get.snackbar("Gagal", hasil["message"]);
                    } else {
                      Get.offAllNamed(Routes.HOME);
                    }
                    controller.isLoading(false);
                  } else {
                    Get.snackbar(
                        "Gagal", "Email dan Password harus di isi dulu");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
              ),
              child: Obx(
                () => Text(controller.isLoading.isFalse ? "LOGIN" : "Loading"),
              ),
            ),
          ],
        ));
  }
}
