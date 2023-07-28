import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/app/data/models/product_models.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);

  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode qtyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";
    return Scaffold(
      appBar: AppBar(
        title: Text('Product ${product.name}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 180,
            width: Get.width,
            child: Center(
              child: QrImageView(
                data: product.code,
                version: QrVersions.auto,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            maxLength: 10,
            controller: codeC,
            readOnly: true,
            focusNode: codeFocusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text("Code Product"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameC,
            focusNode: nameFocusNode,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: Text("Name Product"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: qtyC,
            focusNode: qtyFocusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text("Qty"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  //proses tambah data
                  Map<String, dynamic> hasil = await controller.updateProduct({
                    "uid": product.productId,
                    "name": nameC.text,
                    "qty": int.parse(qtyC.text),
                  });
                  controller.isLoading(false);
                  nameFocusNode.unfocus();
                  qtyFocusNode.unfocus();

                  await Get.snackbar(
                      hasil["error"] == true ? "error" : "Berhasil",
                      hasil["message"]);
                } else {
                  Get.snackbar("Gagal", "Semua inputan wajib di isi");
                }
              }
            },
            child: Obx(
              () => Text(controller.isLoading.isFalse ? "Update" : "Loading"),
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Konfirmasi Delete Product",
                  middleText: "Apakah kamu yakin menghapus product ini ?",
                  actions: [
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          controller.isLoadingDelete(true);
                          //proses hapus
                          Map<String, dynamic> hasil =
                              await controller.deleteProduct(product.productId);
                          controller.isLoadingDelete(false);
                          Get.back();
                          Get.back();
                          Get.snackbar(
                              hasil["error"] == true ? "Gagal" : "Berhasil",
                              hasil["message"],
                              duration: Duration(seconds: 3));
                        },
                        child: Obx(() => controller.isLoadingDelete.isFalse
                            ? Text("Ya")
                            : Container(
                                height: 15,
                                width: 15,
                                padding: EdgeInsets.all(5),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              )))
                  ]);
            },
            child: const Text(
              "Delete this product",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
