class Produto {
  String nome;
  double preco;
  String categoria;
  int estoque;

  Produto({
    required this.nome,
    required this.preco,
    required this.categoria,
    this.estoque = 0,
  });

  Map<String, dynamic> toJson(){
    return{
      'nome': nome,
      'preco': preco,
      'categoria': categoria,
      'estoque': estoque,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json){
    return Produto(
      nome: json['nome'],
      preco: (json['preco'] as num).toDouble(),
      categoria: json['categoria'],
      estoque: json['estoque'] ?? 0,
    );
  }
}