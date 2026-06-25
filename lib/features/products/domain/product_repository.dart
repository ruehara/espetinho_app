import '../../menu/domain/menu_entities.dart';
import 'product_entities.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts();
  Future<List<Product>> getIngredients();

  /// Produtos vendáveis (não internos, ativos) da categoria "Espetos" —
  /// oferecidos como adicionais nos lanches montados.
  Future<List<Product>> getEspetos();
  Future<List<ProductGroup>> getGroups();
  Future<List<Category>> getCategories();
  Future<ProductDetail> loadDetail(int id);
  Future<int> saveProduct(ProductDetail detail);
  Future<void> deleteProduct(int id);
}
