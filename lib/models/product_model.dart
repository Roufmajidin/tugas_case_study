class ProductModel {
  final String image;
  final String expired;
  final String gudang;
  final String stok;
  final String kategori;
  final String id;
  final String namaBarang;

  ProductModel({
    required this.image,
    required this.expired,
    required this.gudang,
    required this.stok,
    required this.kategori,
    required this.id,
    required this.namaBarang,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      image: json['c_image'],
      expired: json['c_expired'],
      gudang: json['c_gudang'],
      stok: json['c_stok'],
      kategori: json['c_kategori'],
      id: json['id'],
      namaBarang: json['c_nama_barang'],
    );
  }
}
