import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../data/app_data.dart';

class PedidoDetalhesPage extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetalhesPage({
    super.key,
    required this.pedido,
  });

  @override
  State<PedidoDetalhesPage> createState() =>
      _PedidoDetalhesPageState();
}

class _PedidoDetalhesPageState extends State<PedidoDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final pedido = widget.pedido;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Pedido"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Cliente: ${pedido.cliente.nome}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Telefone: ${pedido.cliente.telefone}",
              style: const TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Produtos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: pedido.itens.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum produto no pedido.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: pedido.itens.length,

                      itemBuilder: (context, index) {
                        final item = pedido.itens[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),

                          child: ListTile(
                            leading: const Icon(
                              Icons.inventory,
                              color: Colors.orange,
                              size: 32,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),

                                  onPressed: () {
                                    final quantidadeController =
                                        TextEditingController(
                                      text: item.quantidade.toString(),
                                    );

                                    showDialog(
                                      context: context,

                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Editar quantidade",
                                          ),

                                          content: TextField(
                                            controller:
                                                quantidadeController,

                                            keyboardType:
                                                TextInputType.number,

                                            decoration:
                                                const InputDecoration(
                                              labelText:
                                                  "Quantidade",
                                              border:
                                                  OutlineInputBorder(),
                                            ),
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },

                                              child: const Text(
                                                "Cancelar",
                                              ),
                                            ),

                                            ElevatedButton(
                                              onPressed: () async {
                                                final novaQuantidade =
                                                    int.tryParse(
                                                  quantidadeController
                                                      .text,
                                                );

                                                if (novaQuantidade ==
                                                        null ||
                                                    novaQuantidade <=
                                                        0) {
                                                  ScaffoldMessenger
                                                      .of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Digite uma quantidade válida.",
                                                      ),
                                                    ),
                                                  );

                                                  return;
                                                }

                                                final quantidadeAntiga =
                                                    item.quantidade;

                                                final diferenca =
                                                    novaQuantidade -
                                                        quantidadeAntiga;

                                                if (diferenca > 0 &&
                                                    diferenca >
                                                        item.produto
                                                            .estoque) {
                                                  ScaffoldMessenger
                                                      .of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Estoque insuficiente. Disponível: ${item.produto.estoque}",
                                                      ),
                                                    ),
                                                  );

                                                  return;
                                                }

                                                setState(() {
                                                  item.quantidade =
                                                      novaQuantidade;

                                                  item.produto.estoque -=
                                                      diferenca;
                                                });

                                                await AppData
                                                    .salvarDados();

                                                Navigator.pop(
                                                    context);

                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Quantidade atualizada e estoque ajustado!",
                                                    ),
                                                  ),
                                                );
                                              },

                                              child: const Text(
                                                "Salvar",
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),

                                  onPressed: () {
                                    showDialog(
                                      context: context,

                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Excluir produto",
                                          ),

                                          content: Text(
                                            "Deseja remover ${item.produto.nome} deste pedido?",
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },

                                              child: const Text(
                                                "Cancelar",
                                              ),
                                            ),

                                            ElevatedButton(
                                              style:
                                                  ElevatedButton
                                                      .styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                                foregroundColor:
                                                    Colors.white,
                                              ),

                                              onPressed: () async {
                                                setState(() {
                                                  item.produto.estoque +=
                                                      item.quantidade;

                                                  pedido.itens
                                                      .removeAt(
                                                          index);
                                                });

                                                await AppData
                                                    .salvarDados();

                                                Navigator.pop(
                                                    context);

                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Produto removido e estoque restaurado!",
                                                    ),
                                                  ),
                                                );
                                              },

                                              child: const Text(
                                                "Excluir",
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const Divider(),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,

              child: Text(
                "TOTAL: R\$ ${pedido.total.toStringAsFixed(2)}",

                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                icon: const Icon(Icons.delete),

                label: const Text(
                  "Excluir Pedido",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),

                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Excluir Pedido",
                        ),

                        content: Text(
                          "Tem certeza que deseja excluir o pedido de ${pedido.cliente.nome}?",
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: const Text(
                              "Cancelar",
                            ),
                          ),

                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor:
                                  Colors.white,
                            ),

                            onPressed: () async {
                              for (final item
                                  in pedido.itens) {
                                item.produto.estoque +=
                                    item.quantidade;
                              }

                              AppData.pedidos.remove(pedido);

                              await AppData.salvarDados();

                              if (!mounted) {
                                return;
                              }

                              Navigator.pop(context);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Pedido excluído e estoque restaurado!",
                                  ),
                                ),
                              );
                            },

                            child: const Text(
                              "Excluir",
                            ),
                          ),
                        ],
                      );
                    },
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