import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../data/app_data.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  List<Produto> produtos = AppData.produtos;

  final Map<Produto, TextEditingController> estoqueControllers = {};

  TextEditingController controllerEstoque(Produto produto) {
    if (!estoqueControllers.containsKey(produto)) {
      estoqueControllers[produto] = TextEditingController(
        text: produto.estoque.toString(),
      );
    }

    return estoqueControllers[produto]!;
  }

  @override
  void initState() {
    super.initState();

    if (AppData.produtos.isEmpty) {
      AppData.produtos.addAll([
        Produto(
          nome: "X-Burguer",
          preco: 28.90,
          categoria: "Lanche",
          estoque: 20,
        ),
        Produto(
          nome: "Coca-Cola 2L",
          preco: 12.50,
          categoria: "Bebida",
          estoque: 15,
        ),
      ]);
    }

    produtos = AppData.produtos;
  }

  void abrirCadastroProduto() {
    final nomeController = TextEditingController();
    final precoController = TextEditingController();

    String categoriaSelecionada = "Lanche";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Novo Produto"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Preço",
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: categoriaSelecionada,
                    decoration: const InputDecoration(
                      labelText: "Categoria",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Lanche",
                        child: Text("Lanche"),
                      ),
                      DropdownMenuItem(
                        value: "Bebida",
                        child: Text("Bebida"),
                      ),
                      DropdownMenuItem(
                        value: "Sobremesa",
                        child: Text("Sobremesa"),
                      ),
                    ],
                    onChanged: (valor) {
                      setStateDialog(() {
                        categoriaSelecionada = valor!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeController.text.trim().isEmpty ||
                        precoController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Preencha todos os campos."),
                        ),
                      );
                      return;
                    }

                    final preco = double.tryParse(
                      precoController.text.replaceAll(',', '.'),
                    );

                    if (preco == null || preco < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Digite um preço válido."),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      produtos.add(
                        Produto(
                          nome: nomeController.text.trim(),
                          preco: preco,
                          categoria: categoriaSelecionada,
                        ),
                      );
                    });

                    await AppData.salvarDados();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Produto cadastrado com sucesso!",
                        ),
                      ),
                    );
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editarProduto(int index) {
    final nomeController = TextEditingController(
      text: produtos[index].nome,
    );

    final precoController = TextEditingController(
      text: produtos[index].preco.toString(),
    );

    String categoriaSelecionada = produtos[index].categoria;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Editar Produto"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Preço",
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: categoriaSelecionada,
                    decoration: const InputDecoration(
                      labelText: "Categoria",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Lanche",
                        child: Text("Lanche"),
                      ),
                      DropdownMenuItem(
                        value: "Bebida",
                        child: Text("Bebida"),
                      ),
                      DropdownMenuItem(
                        value: "Sobremesa",
                        child: Text("Sobremesa"),
                      ),
                    ],
                    onChanged: (valor) {
                      setStateDialog(() {
                        categoriaSelecionada = valor!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeController.text.trim().isEmpty ||
                        precoController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Preencha todos os campos."),
                        ),
                      );
                      return;
                    }

                    final preco = double.tryParse(
                      precoController.text.replaceAll(',', '.'),
                    );

                    if (preco == null || preco < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Digite um preço válido."),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      produtos[index] = Produto(
                        nome: nomeController.text.trim(),
                        preco: preco,
                        categoria: categoriaSelecionada,
                        estoque: produtos[index].estoque,
                      );
                    });

                    await AppData.salvarDados();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Produto atualizado com sucesso!",
                        ),
                      ),
                    );
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void excluirProduto(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Produto"),
          content: Text(
            "Tem certeza que deseja excluir ${produtos[index].nome}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final produto = produtos[index];

                estoqueControllers[produto]?.dispose();
                estoqueControllers.remove(produto);

                setState(() {
                  produtos.removeAt(index);
                });

                await AppData.salvarDados();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Produto removido com sucesso!",
                    ),
                  ),
                );
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
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

    controllerEstoque(produto).text = novoEstoque.toString();

    await AppData.salvarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Produtos Cadastrados",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: abrirCadastroProduto,
                icon: const Icon(Icons.add),
                label: const Text("Novo Produto"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: "Pesquisar produto",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: const Icon(
                        Icons.inventory,
                        size: 35,
                        color: Colors.orange,
                      ),
                      title: Text(produto.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Categoria: ${produto.categoria}",
                          ),
                          Text(
                            "Preço: R\$ ${produto.preco.toStringAsFixed(2)}",
                          ),
                          Text(
                            "Estoque: ${produto.estoque}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (produto.estoque > 0) {
                                await alterarEstoque(
                                  produto,
                                  produto.estoque - 1,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: controllerEstoque(produto),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 5,
                                ),
                              ),
                              onSubmitted: (valor) async {
                                final novoEstoque = int.tryParse(
                                  valor.trim(),
                                );

                                if (novoEstoque == null ||
                                    novoEstoque < 0) {
                                  controllerEstoque(produto).text =
                                      produto.estoque.toString();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Digite uma quantidade válida.",
                                      ),
                                    ),
                                  );

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
                            onPressed: () async {
                              await alterarEstoque(
                                produto,
                                produto.estoque + 1,
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              editarProduto(index);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              excluirProduto(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
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

  @override
  void dispose() {
    for (final controller in estoqueControllers.values) {
      controller.dispose();
    }

    estoqueControllers.clear();

    super.dispose();
  }
}