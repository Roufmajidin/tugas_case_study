import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_case_study/core/utils/format_date.dart';
import 'package:tugas_case_study/controllers/controller_provider.dart';
import 'package:tugas_case_study/models/single_product_model.dart';
import 'package:tugas_case_study/shared_widget/gudang_widget.dart';
import 'package:tugas_case_study/shared_widget/profile_widget.dart';

class ProductDetailView extends StatefulWidget {
  String id;
  bool isAdjustment;

  ProductDetailView({super.key, required this.id, required this.isAdjustment});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
   late ProductDetail
      productDetail; // Tambahkan variabel untuk menyimpan data produk

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<ControllerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await authProvider.fetchProductById(widget.id);
      productDetail =  authProvider.productDetail!;
      setState(() {
        kodeGudangController.text = authProvider.kodeGudang ?? '';
        namaBarangController.text = productDetail.namaBarang;
        expiredController.text = productDetail.expired;
        stokController.text = productDetail.stok;
        safetyStockController.text = productDetail.safetyStock;
      });
    });
  }

  final kodeGudangController = TextEditingController();
  final namaBarangController = TextEditingController();
  final expiredController = TextEditingController();
  final stokController = TextEditingController();
  final safetyStockController = TextEditingController();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final authProvider = Provider.of<AuthProvider>(context);
  //   productDetail = authProvider.productDetail!;

  //   kodeGudangController.text = authProvider.kodeGudang ?? '';
  //   namaBarangController.text = productDetail.namaBarang;
  //   expiredController.text = productDetail.expired;
  //   stokController.text = productDetail.stok;
  //   safetyStockController.text = productDetail.safetyStock;
  // }

  void submitEdit() async {
    final authProvider = Provider.of<ControllerProvider>(context, listen: false);

    final updatedProduct = ProductDetail(
      id: productDetail.id,
      expired: expiredController.text.isNotEmpty
          ? expiredController.text
          : productDetail.expired,
      createdByName: productDetail.createdByName,
      image: productDetail.image,
      gudang: productDetail.gudang,
      kategori: productDetail.kategori,
      dateModified: DateTime.now().toIso8601String(),
      stok: stokController.text.isNotEmpty
          ? stokController.text
          : productDetail.stok,
      dateCreated: productDetail.dateCreated,
      modifiedByName: productDetail.modifiedByName,
      createdBy: productDetail.createdBy,
      modifiedBy: productDetail.modifiedBy,
      namaBarang: namaBarangController.text.isNotEmpty
          ? namaBarangController.text
          : productDetail.namaBarang,
      safetyStock: safetyStockController.text.isNotEmpty
          ? safetyStockController.text
          : productDetail.safetyStock,
    );

    try {
      await authProvider.updateProductDetail(updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<ControllerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.isAdjustment == true ? "Adjusment Stock" : "Detail",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {},
              child: const Text("Logout", style: TextStyle(color: Colors.black),),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ControllerProvider authProvider, child) {
          var kd = authProvider.kodeGudang;
          final detailProduct = authProvider.productDetail;

          if (authProvider.loadingState == LoadingState.isLoading) {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()));
          }
          if (authProvider.loadingState == LoadingState.isError) {
            return const Center(child: Text("Terjadi Kesalahan"));
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileWidget(
                      nama: authProvider.loginModel!.username,
                      jabatan: authProvider.loginModel!.isAdmin,
                      kode_gudang: kd!),
                  // widget 2
                  const SizedBox(height: 40),
                  GudangWidget(
                    title: detailProduct!.namaBarang,
                    subtitile: "Categori : ${detailProduct.kategori}",
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(
                        Icons.account_tree_sharp,
                        color: Colors.blue,
                        size: 100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeyWidget(),
                      ValueWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SubmitButton(context)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Center SubmitButton(BuildContext context) {
    return Center(
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.deepPurple),
        child: TextButton(
          onPressed: () async {
            submitEdit();
          },
          child: const Text(
            "Request Item",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox KeyWidget() {
    return const SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ID Gudang",
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Nama barang",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Exp Date",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Quantity",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Safety Stock",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ValueWidget() {
    return Consumer(builder: (context, ControllerProvider authProvider, child) {
      var kd = authProvider.kodeGudang;
      final detailProduct = authProvider.productDetail;
      return SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kd!,
              style: const TextStyle(
                  fontSize: 16, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    // initialValue: detailProduct!.namaBarang,
                    controller: namaBarangController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    // initialValue: detailProduct!.expired,
                    controller: expiredController,
                    style: TextStyle(
                      color: isExpired(detailProduct!.expired)
                          ? Colors.red
                          : Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    // initialValue: detailProduct!.stok,
                    controller: stokController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    // initialValue: detailProduct!.safetyStock,
                    controller: safetyStockController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
