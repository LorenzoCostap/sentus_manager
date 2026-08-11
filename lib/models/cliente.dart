class Cliente {

  final String nome;
  final String telefone;

  Cliente({
    required this.nome,
    required this.telefone,
  });

  Map<String, dynamic> toJson(){
    return{
      'nome': nome,
      'telefone': telefone,
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json){
    return Cliente(
      nome: json['nome'],
      telefone: json['telefone'],
    );
  }
}