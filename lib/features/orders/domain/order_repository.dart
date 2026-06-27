import '../../menu/domain/menu_entities.dart';
import '../../products/domain/product_entities.dart';
import 'order_entities.dart';
import 'order_item_signature.dart';

abstract class OrderRepository {
  Stream<List<OrderSummary>> watchOrders();

  /// Produtos vendáveis (cardápio) para montar o pedido.
  Future<List<Product>> sellableProducts();

  /// Stream reativa de produtos vendáveis — emite novamente sempre que o
  /// estoque ou o cadastro de produtos for alterado.
  Stream<List<Product>> watchSellableProducts();

  /// Grupos de produtos (categorias do cardápio), para agrupar a seleção de itens.
  Future<List<ProductGroup>> getGroups();

  /// Categorias do cardápio, para agrupar a seleção de itens.
  Future<List<Category>> getCategories();

  /// Configuração completa de um produto (receita + grupos de escolha).
  Future<ProductDetail> productDetail(int productId);

  /// Produtos de um grupo (usado para sabores via source_group_id).
  Future<List<Product>> productsInGroup(int groupId);

  /// Busca um produto pelo id (usado para validar estoque de opções/adicionais).
  Future<Product?> productById(int id);

  /// Retorna os nomes dos insumos sem estoque suficiente para o item
  /// informado (lista vazia significa que o estoque é suficiente).
  Future<List<String>> checkStock(CartItem item);

  /// Valida a disponibilidade de estoque para um conjunto de itens ainda não
  /// persistidos (ex.: lanches montados antes de entrarem no pedido),
  /// considerando o consumo agregado de receitas e adicionais.
  ///
  /// Os itens em [replacing] têm seu impacto creditado de volta ao estoque
  /// disponível antes da verificação — usado ao editar/substituir um item que
  /// já está no pedido (e cujo estoque já foi abatido).
  ///
  /// Retorna os nomes dos insumos insuficientes (lista vazia = estoque ok).
  Future<List<String>> checkStockForItems(
    List<CartItem> items, {
    List<CartItem> replacing = const [],
  });

  Future<int> createOrder({
    required String customerName,
    required int discountPercent,
    required List<CartItem> items,
    bool confirm = false,
  });

  /// Número sequencial do pedido dentro do dia em que foi aberto (1 para o
  /// primeiro pedido do dia, reiniciando a cada dia). Usado no cabeçalho da
  /// comanda.
  Future<int> dailyOrderNumber(int orderId);

  /// Carrega um pedido aberto para edição.
  Future<OrderDetail> orderDetail(int orderId);

  /// Substitui os itens de um pedido aberto e recalcula o total.
  Future<void> updateOrder({
    required int orderId,
    required String customerName,
    required int discountPercent,
    required List<CartItem> items,
    bool confirm = false,
  });

  /// Fecha o pedido aplicando o desconto informado ao total.
  Future<void> closeOrder(int orderId, {int discountPercent = 0});
  Future<void> deleteOrder(int orderId);

  /// Atualiza apenas o nome do cliente de um pedido já persistido.
  Future<void> renameOrder(int orderId, String customerName);

  /// Calcula o que precisa ser impresso (novo) e o que precisa ser
  /// cancelado/avisado (removido ou reduzido), comparando o estado atual de
  /// [items] com o que já foi impresso anteriormente, para o pedido e tipo
  /// de comanda informados ('kitchen' | 'hall').
  Future<PrintDelta> computePrintDelta({
    required int orderId,
    required String kind,
    required List<CartItem> items,
  });

  /// Registra que o estado atual de [currentItems] foi efetivamente
  /// impresso, atualizando o snapshot persistido para [kind]. A quantidade
  /// gravada por assinatura passa a refletir o total atual (não o delta).
  Future<void> markPrinted({
    required int orderId,
    required String kind,
    required List<CartItem> currentItems,
  });
}
