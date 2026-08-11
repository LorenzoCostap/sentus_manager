import 'package:flutter/material.dart';

import 'clientes_page.dart';
import 'produtos_page.dart';
import 'pedidos_page.dart';
import 'estoque_page.dart';

import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_header.dart';
import '../data/app_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final faturamento = AppData.pedidos.fold<double>(
      0,
      (total, pedido) => total + pedido.total,
    );

    final produtosEstoqueBaixo = AppData.produtos
        .where((produto) => produto.estoque <= 5)
        .length;

    final produtosBaixoEstoque = AppData.produtos
        .where((produto) => produto.estoque <= 5)
        .toList();

    final valorEstoque = AppData.produtos.fold<double>(
      0,
      (total, produto) => total + (produto.preco * produto.estoque),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sentus Manager"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.grey.shade200,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "MENU",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text("Dashboard"),
                  onTap: () {
                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Clientes"),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientesPage(),
                      ),
                    );

                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text("Produtos"),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProdutosPage(),
                      ),
                    );

                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text("Pedidos"),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PedidosPage(),
                      ),
                    );

                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.warehouse),
                  title: const Text("Estoque"),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EstoquePage(),
                      ),
                    );

                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Configurações"),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            children: [
                              DashboardCard(
                                icone: Icons.people,
                                titulo: "Clientes",
                                valor:
                                    AppData.clientes.length.toString(),
                                cor: Colors.blue,
                              ),
                              DashboardCard(
                                icone: Icons.inventory,
                                titulo: "Produtos",
                                valor:
                                    AppData.produtos.length.toString(),
                                cor: Colors.orange,
                              ),
                              DashboardCard(
                                icone: Icons.shopping_cart,
                                titulo: "Pedidos",
                                valor:
                                    AppData.pedidos.length.toString(),
                                cor: Colors.green,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PedidosPage(),
                                    ),
                                  );

                                  setState(() {});
                                },
                              ),
                              DashboardCard(
                                icone: Icons.attach_money,
                                titulo: "Faturamento",
                                valor:
                                    "R\$ ${faturamento.toStringAsFixed(2)}",
                                cor: Colors.purple,
                              ),
                              DashboardCard(
                                icone: Icons.warning,
                                titulo: "Estoque Baixo",
                                valor:
                                    produtosEstoqueBaixo.toString(),
                                cor: Colors.red,
                              ),
                              DashboardCard(
                                icone: Icons.inventory_2,
                                titulo: "Valor em Estoque",
                                valor:
                                    "R\$ ${valorEstoque.toStringAsFixed(2)}",
                                cor: Colors.teal,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Faturamento dos últimos 7 dias",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 250,
                                  child: _GraficoFaturamento(
                                    pedidos: AppData.pedidos,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Produtos com estoque baixo",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if (produtosBaixoEstoque.isEmpty)
                                  const Text(
                                    "Nenhum produto com estoque baixo.",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  )
                                else
                                  ...produtosBaixoEstoque.map(
                                    (produto) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                produto.nome,
                                                style:
                                                    const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${produto.estoque} unidades",
                                              style:
                                                  const TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GraficoFaturamento extends StatelessWidget {
  final List<dynamic> pedidos;

  const _GraficoFaturamento({
    required this.pedidos,
  });

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();

    final valores = List<double>.generate(7, (index) {
      final dia = DateTime(
        hoje.year,
        hoje.month,
        hoje.day - (6 - index),
      );

      double total = 0;

      for (final pedido in pedidos) {
        final data = pedido.data as DateTime;

        if (data.year == dia.year &&
            data.month == dia.month &&
            data.day == dia.day) {
          total += pedido.total;
        }
      }

      return total;
    });

    final maiorValor = valores.isEmpty
        ? 0.0
        : valores.reduce(
            (a, b) => a > b ? a : b,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final valor = valores[index];

              final altura = maiorValor == 0
                  ? 5.0
                  : (valor / maiorValor) * 170;

              final data = DateTime(
                hoje.year,
                hoje.month,
                hoje.day - (6 - index),
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (valor > 0)
                    Text(
                      "R\$ ${valor.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Container(
                    width: 35,
                    height: altura < 5 ? 5 : altura,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${data.day}/${data.month}",
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
