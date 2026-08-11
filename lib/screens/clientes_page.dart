import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../data/app_data.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Cliente> clientes = AppData.clientes;

  List<Cliente> clientesFiltrados = [];

  @override
  void initState() {
    super.initState();

    if (AppData.clientes.isEmpty) {
      AppData.clientes.addAll([
        Cliente(
          nome: "João Silva",
          telefone: "(54) 99999-1111",
        ),
        Cliente(
          nome: "Maria Souza",
          telefone: "(54) 99999-2222",
        ),
        Cliente(
          nome: "Carlos Oliveira",
          telefone: "(54) 99999-3333",
        ),
      ]);
    }

    clientes = AppData.clientes;
    clientesFiltrados = List.from(clientes);
  }

  void pesquisarCliente(String texto) {
    setState(() {
      if (texto.isEmpty) {
        clientesFiltrados = List.from(clientes);
      } else {
        clientesFiltrados = clientes.where((cliente) {
          return cliente.nome
              .toLowerCase()
              .contains(texto.toLowerCase());
        }).toList();
      }
    });
  }

  void abrirCadastroCliente() {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Novo Cliente"),
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
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
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
                if (nomeController.text.isEmpty ||
                    telefoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Preencha todos os campos."),
                    ),
                  );

                  return;
                }

                setState(() {
                  clientes.add(
                    Cliente(
                      nome: nomeController.text,
                      telefone: telefoneController.text,
                    ),
                  );

                  clientesFiltrados = List.from(clientes);
                });

                await AppData.salvarDados();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cliente cadastrado com sucesso!"),
                  ),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void editarCliente(int index) {
    final nomeController = TextEditingController(
      text: clientes[index].nome,
    );

    final telefoneController = TextEditingController(
      text: clientes[index].telefone,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Cliente"),
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
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
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
                if (nomeController.text.isEmpty ||
                    telefoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Preencha todos os campos."),
                    ),
                  );

                  return;
                }

                setState(() {
                  clientes[index] = Cliente(
                    nome: nomeController.text,
                    telefone: telefoneController.text,
                  );
                });

                await AppData.salvarDados();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cliente autilizado com sucesso!"),
                  ),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void excluirCliente(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Cliente"),
          content: Text(
            "Tem certeza que deseja excluir ${clientes[index].nome}?",
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
                setState(() {
                  clientes.removeAt(index);
                });

                await AppData.salvarDados();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cliente removido com sucesso!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Clientes Cadastrados",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                hintText: "Pesquisar cliente...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (texto) {
                pesquisarCliente(texto);
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: abrirCadastroCliente,
                icon: const Icon(Icons.add),
                label: const Text("Novo Cliente"),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: clientesFiltrados.length,
                itemBuilder: (context, index) {
                  final cliente = clientesFiltrados[index];

                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(cliente.nome),
                        subtitle: Text(
                          "Telefone: ${cliente.telefone}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                editarCliente(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                excluirCliente(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
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