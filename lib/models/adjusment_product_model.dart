
class ProductResponse {
  final int total;
  final int size;
  final List<Product> data;

  ProductResponse({
    required this.total,
    required this.size,
    required this.data,
  });
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(
      total: json['total'],
      size: json['size'],
      data: productList,
    );
  }
}

class Product {
  final String expired;
  final String image;
  final String gudang;
  final String kategori;
  final String namaBarang;
  final String stok;

  Product({
    required this.expired,
    required this.image,
    required this.gudang,
    required this.kategori,
    required this.namaBarang,
    required this.stok,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      expired: json['exipred'] ?? '', 
      image: json['image'] ?? '',
      gudang: json['gudang'] ?? '',
      kategori: json['kategori'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      stok: json['stok'] ?? '',
    );
  }
}
