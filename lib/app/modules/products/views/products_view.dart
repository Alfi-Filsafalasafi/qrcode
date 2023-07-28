import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/app/data/models/product_models.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ProductsView'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamProduct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("Tidak ada product"),
                );
              }

              List<ProductModel> allProduct = [];

              for (var element in snapshot.data!.docs) {
                allProduct.add(ProductModel.fromJson(element.data()));
              }

              return ListView.builder(
                  itemCount: allProduct.length,
                  itemBuilder: (context, index) {
                    ProductModel product = allProduct[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                          onTap: () => Get.toNamed(Routes.DETAIL_PRODUCT,
                              arguments: product),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${product.code}"),
                                    SizedBox(height: 4),
                                    Text(
                                      "${product.name}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 4),
                                    Text("${product.qty}")
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QrImageView(
                                    data: "5665656",
                                    size: 200.0,
                                    version: QrVersions.auto,
                                  ),
                                )
                              ],
                            ),
                          )),
                    );
                  });
            }));
  }
}
