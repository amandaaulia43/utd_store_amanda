import '../../../core/network/api_client.dart';
import 'product_model.dart';

class ProductRepository {
  final ApiClient apiClient;

  ProductRepository({required this.apiClient});

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      final List<dynamic> data = response.data;
      
      return data.map((json) {
        final product = ProductModel.fromJson(json);
        // Logika Personal Poin 2 ETS (NIM 43 -> Ganjil -> Diskon 10%)
        return product.copyWith(title: '${product.title} [Diskon 10%]');
      }).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}