import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zybo_cart/Models/BannerModel.dart';
import 'package:zybo_cart/Models/ProductModel.dart';
import 'package:zybo_cart/Models/UserModel.dart';

class ApiRepository {
  static const String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<Map<String, dynamic>> verifyPhone(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify phone number');
    }
  }

  Future<Map<String, dynamic>> loginRegister({
    required String phoneNumber,
    required String firstName,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login-register/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
        'first_name': firstName,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login/register');
    }
  }

  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<BannerModel>> getBanners(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/banners/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch banners');
    }
  }

  Future<List<Product>> searchProducts(String query, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search/?query=$query'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<List<Product>> getWishlist(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch wishlist');
    }
  }

  Future<void> toggleWishlist(int productId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-remove-wishlist/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle wishlist');
    }
  }

  Future<User> getUserData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-data/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
