import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/price_card.dart';
import 'package:novackatelierlojavirtual/models/order.dart';
import 'package:novackatelierlojavirtual/models/page_manager.dart';
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
              if(cartManager.loading){
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                        const SizedBox(height: 16,),
                        Text(
                            'Processando seu Pedido...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                );
              }
              return PriceCard(
                // finalizar o pedido sem pagamento, porque a tela de pagamento não deu certo.
                buttonText: 'Finalizar Pedido',
                onPressed: cartManager.isAddressValid ? () {
                    cartManager.checkout(
                      //mostrando a tela do carrinho com o produto sem estoque
                      onStockFail: (String e){
                        Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                      },
                      onSuccess: (Order order){
                        Navigator.of(context).popUntil((route) => route.settings.name == '/');
                        Navigator.of(context).pushNamed('/confirmation', arguments: order);
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
