import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_case_study/models/adjusment_product_model.dart';
import 'package:tugas_case_study/models/login_models.dart';
import 'package:tugas_case_study/models/product_model.dart';
import 'package:tugas_case_study/models/single_product_model.dart';
import 'package:tugas_case_study/models/user_gudang_model.dart';

enum LoadingState {
  initial,
  isLoading,
  isSuccess,
  isError,
}

class ControllerProvider with ChangeNotifier {
  LoadingState _loadingState = LoadingState.initial;
  LoadingState get loadingState => _loadingState;

  LoginModel? _loginModel;
  LoginModel? get loginModel => _loginModel;
  List<UserGudangModel> _users = [];

  List<UserGudangModel> get users => _users;
  String _kodeGudang = '';
  String? get kodeGudang => _kodeGudang;
  ProductDetail? _productDetail;

  ProductDetail? get productDetail => _productDetail;
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  List<Product> _productsAdjusment = [];
  List<Product> get productsAdjusment => _productsAdjusment;

  static const String apiKey = '6a9ed2eaf0ff4274ab2370bed8ea31fc';
  static const String apiId = 'API-b8b98d97-008d-4b83-aa59-cb133665638b';
  Future<void> loginProcess(String username, String password) async {
    _loadingState = LoadingState.isLoading;
    notifyListeners();

    final url = Uri.parse('https://itasoft.int.joget.cloud/jw/api/sso');
    final headers = {
      'api_key': '6a9ed2eaf0ff4274ab2370bed8ea31fc',
      'api_id': 'API-b8b98d97-008d-4b83-aa59-cb133665638b',
    };
    final body = {
      'j_username': username,
      'j_password': password,
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _loginModel = LoginModel.fromJson(responseData);

        _loadingState = LoadingState.isSuccess;
        notifyListeners();
      } else {
        _loadingState = LoadingState.isError;
        notifyListeners();
      }
    } catch (error) {
      _loadingState = LoadingState.isError;
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> fetchUserGudang() async {
    _loadingState = LoadingState.isLoading;
    notifyListeners();
    final url = Uri.parse(
        'https://itasoft.int.joget.cloud/jw/api/list/list_frmUserMapping');

    try {
      final response = await http.get(url, headers: {
        'api_key': apiKey,
        'api_id': apiId,
      });

      if (response.statusCode == 200) {
        _loadingState = LoadingState.isSuccess;
        notifyListeners();
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<UserGudangModel> loadedUsers = [];

        extractedData['data'].forEach((userData) {
          loadedUsers.add(UserGudangModel.fromJson(userData));
        });

        _users = loadedUsers;
        // log(_users.toString());
        var a = filterByUserName(_loginModel!.username);
        _kodeGudang = a.first.kodeGudang.toString();
        log(_kodeGudang);
        // for (var element in a) {}
        notifyListeners();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      throw Exception('Error fetching user data: $error');
    }
  }

  List<UserGudangModel> filterByUserName(String userName) {
    return _users.where((user) => user.userName == userName).toList();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://itasoft.int.joget.cloud/jw/api/list/list_formStokBarang?pageSize=10&startOffset=1');

    try {
      final response = await http.get(url, headers: {
        'api_key': apiKey,
        'api_id': apiId,
      });

      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<ProductModel> loadedProducts = [];

        extractedData['data'].forEach((productData) {
          loadedProducts.add(ProductModel.fromJson(productData));
        });

        _products = loadedProducts;
        // for (var e in _products) {

        // log(e.gudang.toString());
        // }
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  List<ProductModel> filterByGudang(String gudangCode) {
    return _products.where((product) => product.gudang == gudangCode).toList();
  }
  List<Product> filterByGudangAdjusment(String gudangCode) {
    return _productsAdjusment.where((product) => product.gudang == gudangCode).toList();
  }

  Future<ProductDetail?> fetchProductById(String id) async {
    _loadingState = LoadingState.isLoading;
    notifyListeners();
    final url = Uri.parse(
        'https://itasoft.int.joget.cloud/jw/api/form/formStokBarang/$id');

    try {
      final response = await http.get(url, headers: {
        'api_key': apiKey,
        'api_id': apiId,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _productDetail = ProductDetail.fromJson(data);
        _loadingState = LoadingState.isSuccess;
        notifyListeners();
        log(_productDetail!.kategori.toString());

        return ProductDetail.fromJson(data);
      } else {
        _loadingState = LoadingState.isError;
        notifyListeners();
        throw Exception('Failed to load product');
      }
    } catch (error) {
      throw Exception('Error fetching product: $error');
    }
  }

  Future<void> updateProductDetail(ProductDetail product) async {
    final url = Uri.parse(
        'https://itasoft.int.joget.cloud/jw/api/form/formStokBarang/${product.id}');

    final response = await http.post(
      url,
      headers: {
        'api_key': apiKey,
        'api_id': apiId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_barang": product.id,
        "expired": product.expired,
        "createdByName": product.createdByName,
        "image": product.image,
        "gudang": product.gudang,
        "kategori": product.kategori,
        "dateModified": product.dateModified,
        "stok": product.stok,
        "dateCreated": product.dateCreated,
        "modifiedByName": product.modifiedByName,
        "createdBy": product.createdBy,
        "modifiedBy": product.modifiedBy,
        "nama_barang": product.namaBarang,
        "safetyStock": product.safetyStock,
      }),
    );

    if (response.statusCode == 200) {
      log('status ${response.body}');
      notifyListeners();
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> fetchProductsAdjusment() async {
    _loadingState = LoadingState.isLoading;
    notifyListeners();

    final url = Uri.parse(
        'https://itasoft.int.joget.cloud/jw/api/list/listAdjustmentStok?pageSize=90&startOffset=1');
    try {
      final response = await http.get(url, headers: {
        'api_key': '6a9ed2eaf0ff4274ab2370bed8ea31fc',
        'api_id': 'API-b8b98d97-008d-4b83-aa59-cb133665638b',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ProductResponse productResponse = ProductResponse.fromJson(data);
        _productsAdjusment = productResponse.data;
        _loadingState = LoadingState.isSuccess;
        notifyListeners();
      } else {
        _loadingState = LoadingState.isError;
        notifyListeners();
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw error; // Handle any errors
    } finally {
      notifyListeners();
    }
  }
}
