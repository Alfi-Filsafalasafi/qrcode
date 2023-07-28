import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode qtyFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddProductView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              maxLength: 10,
              controller: codeC,
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
                  if (nameC.text.isNotEmpty &&
                      codeC.text.isNotEmpty &&
                      qtyC.text.isNotEmpty) {
                    controller.isLoading(true);
                    //proses tambah data
                    Map<String, dynamic> hasil = await controller.addProduct({
                      "code": codeC.text,
                      "name": nameC.text,
                      "qty": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoading(false);
                    print(hasil["error"]);
                    if (hasil["error"] == false) {
                      codeC.text = "";
                      nameC.text = "";
                      qtyC.text = "";
                      codeFocusNode.unfocus();
                      nameFocusNode.unfocus();
                      qtyFocusNode.unfocus();
                    }

                    await Get.snackbar(
                        hasil["error"] == true ? "error" : "Berhasil",
                        hasil["message"]);
                  } else {
                    Get.snackbar("Gagal", "Semua inputan wajib di isi");
                  }
                }
              },
              child: Obx(
                () => Text(controller.isLoading.isFalse ? "Simpan" : "Loading"),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ));
  }
}
