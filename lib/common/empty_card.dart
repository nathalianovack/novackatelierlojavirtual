// O EMPTY CARD É PARA MOSTRAR AO USUÁRIO QUE ELE NÃO TEM NENHUM ITEM NO CARRINHO QUANDO SOLICITA PARA VER O CARRINHO OU QUE NÃO TEM NENHUM PEDIDO NOS MEUS PEDIDOS.
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {

  const EmptyCard({this.title, this.iconData});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 100.0,
            color: Colors.white,
          ),
          const SizedBox(height: 16.0,),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}