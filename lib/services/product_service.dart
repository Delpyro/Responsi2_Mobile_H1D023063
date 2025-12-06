import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class ProductService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> getProducts() async {
    final token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.products),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          return json['data']; 
        }
      }
    } catch (e) {
      print("Error getProducts: $e");
    }
    return [];
  }

  Future<bool> deleteProduct(int id) async {
    final token = await _getToken();
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.products}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleteProduct: $e");
      return false;
    }
  }
}