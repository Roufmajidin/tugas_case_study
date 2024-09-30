import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_case_study/core/utils/format_date.dart';
import 'package:tugas_case_study/controllers/controller_provider.dart';
import 'package:tugas_case_study/pages/product/product_detail.dart';
import 'package:tugas_case_study/shared_widget/gudang_widget.dart';
import 'package:tugas_case_study/shared_widget/profile_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title});

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    callFunc();
  }

  Future<void> callFunc() async {
    final authProvider = Provider.of<ControllerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String username = authProvider.loginModel!.username;
      authProvider.fetchUserGudang();
      authProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
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
        child: RefreshIndicator(
          onRefresh: callFunc,
          child: Consumer(builder: (context, ControllerProvider authProvider, child) {
            var kd = authProvider.kodeGudang;
            final filteredProducts = authProvider.filterByGudang(kd!);
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
                        kode_gudang: kd),
                    // widget 2
                    const SizedBox(height: 16),
                    GudangWidget(
                      title: "Gudang $kd",
                      subtitile: "Makanan, Minuman, stationary, Medicine  ",
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        height: 50,

                        // width: ,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            // initialValue: detailProduct!.stok,
                            // controller: stokController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.sort_outlined),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search_outlined),

                            ),

                          ),
                        ),
                      ),
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 2,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children:
                            List.generate(filteredProducts.length, (index) {
                          final product = filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              authProvider.fetchProductById(product.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailView(
                                          id: product.id,
                                          isAdjustment:
                                              isExpired(product.expired),
                                        )),
                              );
                            },
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.inventory,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.kategori,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        // Text('Stok: ${product.cStok}'),
                                        Text(
                                          formatTanggal(
                                            product.expired,
                                          ),
                                          style: TextStyle(
                                            color: isExpired(product.expired)
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                        ),
                                        // Text('Stok: ${product.stok}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      // floatingActionButton: Consumer(
      //   builder: (context, AuthProvider authhProvider, child) {
      //     return FloatingActionButton(
      //       onPressed: () {},
      //       tooltip: 'Increment',
      //       child: const Icon(Icons.add),
      //     );
      //   },
      // ),
    );
  }
}
