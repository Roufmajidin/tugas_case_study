class UserGudangModel {
  final String userName;
  final String kodeGudang;

  UserGudangModel({
    required this.userName,
    required this.kodeGudang,
  });

  factory UserGudangModel.fromJson(Map<String, dynamic> json) {
    return UserGudangModel(
      userName: json['user_name'],
      kodeGudang: json['kode_gudang'],
    );
  }
}
