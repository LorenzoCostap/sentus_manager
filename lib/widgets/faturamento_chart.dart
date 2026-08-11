import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/app_data.dart';

class FaturamentoChart extends StatelessWidget {
  const FaturamentoChart({super.key});

  @override
  Widget build(BuildContext context) {
    final agora = DateTime.now();

    final ultimos7Dias = List.generate(
      7,
      (index) => DateTime(
        agora.year,
        agora.month,
        agora.day - (6 - index),
      ),
    );

    final valores = ultimos7Dias.map((dia) {
      double total = 0;

      for (final pedido in AppData.pedidos) {
        final dataPedido = pedido.data;

        if (dataPedido.year == dia.year &&
            dataPedido.month == dia.month &&
            dataPedido.day == dia.day) {
          total += pedido.total;
        }
      }

      return total;
    }).toList();

    double maiorValor = 0;

    for (final valor in valores) {
      if (valor > maiorValor) {
        maiorValor = valor;
      }
    }

    if (maiorValor == 0) {
      maiorValor = 100;
    }

    return Container(
      width: double.infinity,
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Faturamento dos últimos 7 dias",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maiorValor * 1.2,

                gridData: FlGridData(
                  show: true,
                ),

                borderData: FlBorderData(
                  show: false,
                ),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "R\$ ${value.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= 7) {
                          return const SizedBox();
                        }

                        final dia = ultimos7Dias[index];

                        return Text(
                          "${dia.day}/${dia.month}",
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      valores.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        valores[index],
                      ),
                    ),

                    isCurved: true,

                    barWidth: 4,

                    dotData: FlDotData(
                      show: true,
                    ),

                    belowBarData: BarAreaData(
                      show: true,
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