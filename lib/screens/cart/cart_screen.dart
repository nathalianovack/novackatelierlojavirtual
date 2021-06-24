import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/empty_card.dart';
import 'package:novackatelierlojavirtual/common/login_card.dart';
import 'package:novackatelierlojavirtual/common/price_card.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
          //verificando se o usuário está logado.
          if(cartManager.user == null){
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return EmptyCard(
              iconData: Icons.remove_shopping_cart_outlined,
              title: 'Nenhum produto no carrinho!' ,
            );
          }

          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items.map((cartProduct) => CartTile(cartProduct)).toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed('/address');
                }: null,
              ),
            ],
          );
        },
      ),
    );
  }
}
