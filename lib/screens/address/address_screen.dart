import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/price_card.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/screens/address/components/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __){
              return PriceCard(
                // finalizar o pedido sem pagamento, porque a tela de pagamento não deu certo.
                buttonText: 'Finalizar Pedido',
                onPressed: cartManager.isAddressValid ? () {
                 // Navigator.of(context).pushNamed('/checkout');
                    cartManager.checkout(
                      //mostrando a tela do carrinho com o produto sem estoque
                      onStockFail: (e){
                        Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                      }
                    );
                    } : null
                  );
                }
              )
            ],
          ),
        );
     }
}
