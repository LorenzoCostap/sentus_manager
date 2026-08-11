import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;
  final Color cor;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
    required this.cor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icone,
                size: 50,
                color: cor,
              ),
              const SizedBox(height: 15),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}