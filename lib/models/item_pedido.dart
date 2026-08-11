import 'produto.dart';

class ItemPedido {
  Produto produto;
  int quantidade;

  ItemPedido({
    required this.produto,
    required this.quantidade,
  });

  double get subtotal {
    return produto.preco * quantidade;
  }

  Map<String, dynamic> toJson(){
    return{
      'produto': produto.toJson(),
      'quantidade': quantidade,
    };
  }

  factory ItemPedido.fromJson(Map<String, dynamic> json){
    return ItemPedido(
      produto: Produto.fromJson(
        Map<String, dynamic>.from(json['produto']),
      ),

      quantidade: json['quantidade'],
    );
  }
}