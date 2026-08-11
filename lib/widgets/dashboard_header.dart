import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: const [

        Text(
          "Bem-vindo ao MLA Manager",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text(
          "Sistema de gestão empresarial",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),

      ],

    );

  }

}