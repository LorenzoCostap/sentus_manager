import 'package:flutter/material.dart';
import '../data/app_data.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int get totalClientes {
    return AppData.clientes.length;
  }

  int get totalProdutos {
    return AppData.produtos.length;
  }

  int get totalPedidos {
    return AppData.pedidos.length;
  }

  double get totalVendas {
    double total = 0;

    for (final pedido in AppData.pedidos) {
      total += pedido.total;
    }

    return total;
  }

  int get produtosEstoqueBaixo {
    int total = 0;

    for (final produto in AppData.produtos) {
      if (produto.estoque <= 5) {
        total++;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Visão geral do sistema",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final largura = constraints.maxWidth;

                  int colunas;

                  if (largura >= 1100) {
                    colunas = 4;
                  } else if (largura >= 700) {
                    colunas = 2;
                  } else {
                    colunas = 1;
                  }

                  return GridView.count(
                    crossAxisCount: colunas,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _CardResumo(
                        titulo: "Clientes",
                        valor: totalClientes.toString(),
                        icone: Icons.people,
                        cor: Colors.blue,
                      ),
                      _CardResumo(
                        titulo: "Produtos",
                        valor: totalProdutos.toString(),
                        icone: Icons.inventory,
                        cor: Colors.orange,
                      ),
                      _CardResumo(
                        titulo: "Pedidos",
                        valor: totalPedidos.toString(),
                        icone: Icons.shopping_cart,
                        cor: Colors.green,
                      ),
                      _CardResumo(
                        titulo: "Vendas",
                        valor: "R\$ ${totalVendas.toStringAsFixed(2)}",
                        icone: Icons.attach_money,
                        cor: Colors.purple,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Estoque baixo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "$produtosEstoqueBaixo produto(s)",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    "5 unidades ou menos",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Últimos pedidos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              AppData.pedidos.isEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Nenhum pedido cadastrado.",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: AppData.pedidos.reversed
                          .take(5)
                          .map(
                            (pedido) {
                              return Card(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    pedido.cliente.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${pedido.itens.length} produto(s)",
                                  ),
                                  trailing: Text(
                                    "R\$ ${pedido.total.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                          .toList(),
                    ),
              const SizedBox(height: 30),
              const Text(
                "Produtos com estoque baixo",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Builder(
                builder: (context) {
                  final produtosBaixo = AppData.produtos
                      .where((produto) => produto.estoque <= 5)
                      .toList();

                  if (produtosBaixo.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Todos os produtos possuem estoque suficiente.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: produtosBaixo.map(
                      (produto) {
                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.inventory,
                              color: Colors.orange,
                            ),
                            title: Text(
                              produto.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Categoria: ${produto.categoria}",
                            ),
                            trailing: Text(
                              "${produto.estoque} unidade(s)",
                              style: TextStyle(
                                color: produto.estoque == 0
                                    ? Colors.red
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardResumo extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;

  const _CardResumo({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icone,
                color: cor,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}