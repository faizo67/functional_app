import 'package:dio/dio.dart';
import '../models/product_model.dart';

class HomeRepository {
  final Dio dio;
  HomeRepository(this.dio);

  Future<List<ProductModel>> fetchProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
