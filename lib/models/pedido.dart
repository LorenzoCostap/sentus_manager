import 'cliente.dart';
import 'item_pedido.dart';

class Pedido {
  Cliente cliente;
  List<ItemPedido> itens;
  DateTime data;

  Pedido({
    required this.cliente,
    required this.itens,
    DateTime? data,
  }) : data = data ?? DateTime.now();

  double get total {
    double soma = 0;

    for (var item in itens) {
      soma += item.subtotal;
    }

    return soma;
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': cliente.toJson(),
      'itens': itens.map((item) => item.toJson()).toList(),
      'data': data.toIso8601String(),
    };
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      cliente: Cliente.fromJson(
        Map<String, dynamic>.from(json['cliente']),
      ),
      itens: (json['itens'] as List)
          .map(
            (item) => ItemPedido.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      data: json['data'] != null
          ? DateTime.parse(json['data'])
          : DateTime.now(),
    );
  }
}