import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';
import '../models/item_pedido.dart';

import 'pedido_detalhes_page.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  Cliente? clienteSelecionado;
  Produto? produtoSelecionado;

  final quantidadeController = TextEditingController();

  final List<ItemPedido> itensPedido = [];

  void adicionarProduto(StateSetter setStateDialog) {
    if (produtoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione um produto."),
        ),
      );

      return;
    }

    final quantidade = int.tryParse(
      quantidadeController.text,
    );

    if (quantidade == null || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite uma quantidade válida."),
        ),
      );

      return;
    }

    setStateDialog(() {
      itensPedido.add(
        ItemPedido(
          produto: produtoSelecionado!,
          quantidade: quantidade,
        ),
      );

      produtoSelecionado = null;
      quantidadeController.clear();
    });
  }

  Future<bool> salvarPedido() async {
    if (clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione um cliente."),
        ),
      );

      return false;
    }

    if (itensPedido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adicione pelo menos um produto."),
        ),
      );

      return false;
    }

    for (final item in itensPedido) {
      if (item.quantidade > item.produto.estoque) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Estoque insuficiente para ${item.produto.nome}.",
            ),
          ),
        );

        return false;
      }
    }

    final pedido = Pedido(
      cliente: clienteSelecionado!,
      itens: List.from(itensPedido),
    );

    setState(() {
      AppData.pedidos.add(pedido);

      for (final item in itensPedido) {
        item.produto.estoque -= item.quantidade;
      }
    });

    await AppData.salvarDados();

    if (!mounted) {
      return false;
    }

    itensPedido.clear();
    clienteSelecionado = null;
    produtoSelecionado = null;
    quantidadeController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Pedido criado e estoque atualizado!",
        ),
      ),
    );

    return true;
  }

  void abrirNovoPedido() {
    clienteSelecionado = AppData.clientes.isNotEmpty
        ? AppData.clientes.first
        : null;

    produtoSelecionado = null;

    itensPedido.clear();
    quantidadeController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Novo Pedido"),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Cliente>(
                        initialValue: clienteSelecionado,
                        decoration: const InputDecoration(
                          labelText: "Cliente",
                          border: OutlineInputBorder(),
                        ),
                        items: AppData.clientes.map((cliente) {
                          return DropdownMenuItem<Cliente>(
                            value: cliente,
                            child: Text(cliente.nome),
                          );
                        }).toList(),
                        onChanged: (cliente) {
                          setStateDialog(() {
                            clienteSelecionado = cliente;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<Produto>(
                        initialValue: produtoSelecionado,
                        decoration: const InputDecoration(
                          labelText: "Produto",
                          border: OutlineInputBorder(),
                        ),
                        items: AppData.produtos.map((produto) {
                          return DropdownMenuItem<Produto>(
                            value: produto,
                            child: Text(
                              "${produto.nome} - R\$ ${produto.preco.toStringAsFixed(2)}",
                            ),
                          );
                        }).toList(),
                        onChanged: (produto) {
                          setStateDialog(() {
                            produtoSelecionado = produto;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: quantidadeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Quantidade",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            adicionarProduto(setStateDialog);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text(
                            "Adicionar Produto",
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (itensPedido.isNotEmpty)
                        Column(
                          children: [
                            const Divider(),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Produtos adicionados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            ...itensPedido.asMap().entries.map(
                              (entry) {
                                final indexItem = entry.key;
                                final item = entry.value;

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    Icons.inventory,
                                    color: Colors.orange,
                                  ),
                                  title: Text(
                                    item.produto.nome,
                                  ),
                                  subtitle: Text(
                                    "${item.quantidade} x R\$ ${item.produto.preco.toStringAsFixed(2)}",
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "R\$ ${item.subtotal.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      IconButton(
                                        onPressed: () {
                                          setStateDialog(() {
                                            itensPedido.removeAt(
                                              indexItem,
                                            );
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const Divider(),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Total: R\$ ${itensPedido.fold<double>(
                                  0,
                                  (total, item) =>
                                      total + item.subtotal,
                                ).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    itensPedido.clear();

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (clienteSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Selecione um cliente.",
                          ),
                        ),
                      );

                      return;
                    }

                    if (itensPedido.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Adicione pelo menos um produto.",
                          ),
                        ),
                      );

                      return;
                    }

                    final sucesso = await salvarPedido();

                    if (!dialogContext.mounted) {
                      return;
                    }

                    if (sucesso) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text("Salvar Pedido"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Pedidos",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,

              child: ElevatedButton.icon(
                onPressed: abrirNovoPedido,

                icon: const Icon(Icons.add),

                label: const Text(
                  "Novo Pedido",
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: AppData.pedidos.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum pedido cadastrado.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: AppData.pedidos.length,

                      itemBuilder: (context, index) {
                        final pedido = AppData.pedidos[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 15,
                          ),

                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.shopping_cart,
                              ),
                            ),

                            title: Text(
                              pedido.cliente.nome,
                            ),

                            subtitle: Text(
                              "${pedido.itens.length} produto(s)",
                            ),

                            trailing: Text(
                              "R\$ ${pedido.total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PedidoDetalhesPage(
                                    pedido: pedido,
                                  ),
                                ),
                              );
                            },
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
    quantidadeController.dispose();

    super.dispose();
  }
}