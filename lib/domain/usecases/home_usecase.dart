import '../../data/repositorie/home_repository.dart';
import '../../data/models/product_model.dart';

class HomeUseCase {
  final HomeRepository _homeRepository;
  HomeUseCase(this._homeRepository);

  Future<List<ProductModel>> fetchProducts() async {
    return await _homeRepository.fetchProducts();
  }
}
