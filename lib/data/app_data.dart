import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';
import '../services/storage_service.dart';

class AppData {

  static List<Cliente> clientes = [];

  static List<Produto> produtos = [];

  static List<Pedido> pedidos = [];

  static Future<void> carregarDados() async{
    final clientesSalvos = await StorageService.carregar(
      StorageService.clientesKey,
    );

    final produtosSalvos = await StorageService.carregar(
      StorageService.produtosKey,
    );

    final pedidosSalvos = await StorageService.carregar(
      StorageService.pedidosKey,
    );

    clientes = clientesSalvos
    .map((json) => Cliente.fromJson(json))
    .toList();

    produtos = produtosSalvos
    .map((json) => Produto.fromJson(json))
    .toList();

    pedidos = pedidosSalvos
    .map((json) => Pedido.fromJson(json))
    .toList();
  }

  static Future<void> salvarDados() async{
    await StorageService.salvarDados(
      clientes: clientes
      .map((cliente) => cliente.toJson())
      .toList(),

      produtos: produtos
      .map((produto) => produto.toJson())
      .toList(),

      pedidos: pedidos
      .map((pedido) => pedido.toJson())
      .toList(),
    );
  }
}