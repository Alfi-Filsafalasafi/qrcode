import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/models/product_models.dart';

class HomeController extends GetxController {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  RxList<ProductModel> allProduct = List<ProductModel>.empty().obs;
  void downloadCatalog() async {
    try {
      final pdf = pw.Document();

      var getData = await firebase.collection("products").get();
      //reset allProduct
      allProduct([]);
      //isi kembali allProduct
      for (var element in getData.docs) {
        allProduct.add(ProductModel.fromJson(element.data()));
      }
      pdf.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              List<pw.TableRow> allData = List.generate(
                allProduct.length,
                (index) {
                  ProductModel product = allProduct[index];
                  return pw.TableRow(
                    children: [
                      //no
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          "${index + 1}",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      //kode barang
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          product.code,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      //Nama Barang
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          product.name,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      //Quantyty
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          "${product.qty}",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      // QR Code
                      pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: "${product.code}",
                          color: PdfColor.fromHex("#000000"),
                          height: 70,
                        ),
                      ),
                    ],
                  );
                },
              );
              return [
                pw.Center(
                  child: pw.Text(
                    "Catalog",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 36),
                  ),
                ),
                pw.SizedBox(height: 50),
                pw.Table(
                    border: pw.TableBorder.all(
                      width: 2,
                      color: PdfColor.fromHex("#000000"),
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          //no
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "No",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          //kode barang
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Kode Barang",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          //Nama Barang
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Nama Barang",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          //Quantyty
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "QTY",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          // QR Code
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "QR Code",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      ...allData,
                    ]),
              ];
            }),
      );

      //simpan
      Uint8List bytes = await pdf.save();

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/hallo.pdf");
      print(file);

      //memasukkan data pada bytes
      await file.writeAsBytes(bytes);

      await OpenFile.open(file.path);
      print("berhasil");
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getProductByBarcID(String codeBarang) async {
    try {
      var hasil = await firebase
          .collection("products")
          .where("code", isEqualTo: codeBarang)
          .get();
      print("ini hasilnya");
      print(hasil.docs.first.data());
      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak mendapatkan produk dari barcode ini di database",
        };
      }
      return {
        "error": false,
        "message": "Berhasil mengambil data",
        "data": ProductModel.fromJson(hasil.docs.first.data()!),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat memproses hasil scan",
      };
    }
  }
}
