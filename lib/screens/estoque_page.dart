import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../data/app_data.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();

    produtos = AppData.produtos;
  }

  Future<void> alterarEstoque(
    Produto produto,
    int novoEstoque,
  ) async {
    if (novoEstoque < 0) {
      return;
    }

    setState(() {
      produto.estoque = novoEstoque;
    });

    await AppData.salvarDados();
  }

  Future<void> diminuirEstoque(Produto produto) async {
    if (produto.estoque <= 0) {
      return;
    }

    await alterarEstoque(
      produto,
      produto.estoque - 1,
    );
  }

  Future<void> aumentarEstoque(Produto produto) async {
    await alterarEstoque(
      produto,
      produto.estoque + 1,
    );
  }

  void mostrarErro() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Digite uma quantidade válida.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estoque"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Controle de Estoque",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: produtos.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum produto cadastrado.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.inventory,
                                  size: 40,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produto.nome,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Categoria: ${produto.categoria}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Preço: R\$ ${produto.preco.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    diminuirEstoque(produto);
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: TextFormField(
                                    key: ValueKey(
                                      "${produto.nome}_${produto.estoque}",
                                    ),
                                    initialValue:
                                        produto.estoque.toString(),
                                    textAlign: TextAlign.center,
                                    keyboardType:
                                        TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 5,
                                      ),
                                    ),
                                    onFieldSubmitted: (valor) async {
                                      final novoEstoque =
                                          int.tryParse(valor);

                                      if (novoEstoque == null ||
                                          novoEstoque < 0) {
                                        mostrarErro();
                                        return;
                                      }

                                      await alterarEstoque(
                                        produto,
                                        novoEstoque,
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    aumentarEstoque(produto);
                                  },
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}