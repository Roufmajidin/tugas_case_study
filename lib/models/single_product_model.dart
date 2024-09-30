class ProductDetail {
  final String createdByName;
  final String image;
  final String safetyStock;
  final String gudang;
  final String dateModified;
  final String kategori;
  final String stok;
  final String modifiedByName;
  final String dateCreated;
  final String expired;
  final String createdBy;
  final String modifiedBy;
  final String namaBarang;
  final String id;

  ProductDetail({
    required this.createdByName,
    required this.image,
    required this.safetyStock,
    required this.gudang,
    required this.dateModified,
    required this.kategori,
    required this.stok,
    required this.modifiedByName,
    required this.dateCreated,
    required this.expired,
    required this.createdBy,
    required this.modifiedBy,
    required this.namaBarang,
    required this.id,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      createdByName: json['createdByName'],
      image: json['image'],
      safetyStock: json['safety_stok'],
      gudang: json['gudang'],
      dateModified: json['dateModified'],
      kategori: json['kategori'],
      stok: json['stok'],
      modifiedByName: json['modifiedByName'],
      dateCreated: json['dateCreated'],
      expired: json['expired'],
      createdBy: json['createdBy'],
      modifiedBy: json['modifiedBy'],
      namaBarang: json['nama_barang'],
      id: json['id'],
    );
  }
}
