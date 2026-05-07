import '../../../../core/network/api_client.dart';
import 'product_model.dart';

class ProductRepository {
  final ApiClient apiClient;

  ProductRepository(this.apiClient);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }
}