import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget{
  final IconData icone;
  final String titulo;
  final String valor;
  final Color cor;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 6,

      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        onTap: onTap,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children:[

              Icon(
                icone,
                color: cor,
                size: 70,
              ),

              const SizedBox(height: 15),

              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
               
               const SizedBox(height:10),
                Text(
                valor,
                style:TextStyle(
                  fontSize:28,
                  fontWeight: FontWeight.bold,
                  color: cor, 
                ),
               ),
            
            
            ],
          ),
        ),
      ),
    );
  }
}