# Sentus Manager

O Sentus Manager é um projeto que desenvolvi em Flutter para colocar em prática o que venho aprendendo sobre Dart e desenvolvimento de aplicações.

A ideia surgiu da vontade de criar algo mais completo do que exercícios isolados. Por isso, escolhi desenvolver um sistema de gerenciamento inspirado nas necessidades de pequenos negócios, reunindo clientes, produtos, estoque e pedidos em uma única aplicação.

---

## Sobre o projeto

Durante o desenvolvimento, procurei simular situações que poderiam acontecer em um sistema real. Um exemplo é a criação de pedidos: o usuário escolhe um cliente, adiciona os produtos e informa as quantidades. O sistema calcula o valor total e, quando o pedido é finalizado, atualiza o estoque automaticamente.

Também criei um dashboard para apresentar as principais informações de forma simples, como quantidade de clientes, produtos cadastrados, pedidos realizados, vendas e itens com estoque baixo.

---

## Funcionalidades

* Cadastro, edição e exclusão de clientes;
* Cadastro, edição e exclusão de produtos;
* Organização dos produtos por categorias;
* Controle de preços e quantidades em estoque;
* Criação e gerenciamento de pedidos;
* Associação de pedidos aos clientes;
* Cálculo automático do valor total;
* Atualização do estoque depois de cada venda;
* Identificação de produtos com estoque baixo;
* Dashboard com um resumo do sistema;
* Armazenamento dos dados da aplicação.

---

## Como funciona

O sistema possui diferentes áreas:

**Dashboard:** apresenta um resumo do sistema, mostrando quantidade de clientes, produtos, pedidos, vendas e produtos com estoque baixo.

**Clientes:** permite cadastrar e gerenciar os clientes do sistema.

**Produtos:** permite cadastrar produtos, definir preços, categorias e controlar suas quantidades em estoque.

**Pedidos:** permite selecionar um cliente, adicionar produtos e suas quantidades e criar um pedido. Ao finalizar o pedido, o estoque dos produtos é atualizado automaticamente.

**Estoque:** permite acompanhar os produtos e suas respectivas quantidades disponíveis.

---

## Tecnologias utilizadas

Para desenvolver o projeto, utilizei:

* Flutter;
* Dart;
* Material Design.
