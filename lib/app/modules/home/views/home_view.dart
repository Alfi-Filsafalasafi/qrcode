import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/auth_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Add Product";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.ADD_PRODUCT);
              break;
            case 1:
              title = "Products";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.PRODUCTS);

              break;
            case 2:
              title = "Qr Code";
              icon = Icons.qr_code_2_outlined;
              onTap = () {
                print("Open Camera");
              };
              break;
            case 3:
              title = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () {
                print("Open Pdf");
              };
              break;
          }
          return Material(
            color: Colors.blue[300],
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      icon,
                      size: 49,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == true) {
            Get.snackbar("Gagal", hasil["message"]);
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        },
        child: const Icon(Icons.logout_outlined),
      ),
    );
  }
}
