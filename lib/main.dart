import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'data/app_data.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await AppData.carregarDados();

  runApp(const SentusManager());
}

class SentusManager extends StatelessWidget{
  const SentusManager({super.key});

  @override

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Sentus Manager',
      home: const LoginPage(),
    );
  }
}