import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/models/product.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {

  ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/edit_product', arguments: product);
                  });
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 1,
                child: Carousel(
                    images: product.images.map((url){
                      return NetworkImage(url);
                    }).toList(),
                  dotSize: 4,
                  dotSpacing: 15,
                  dotPosition: DotPosition.bottomCenter,
                  dotBgColor: Colors.transparent,
                  dotColor: primaryColor,
                  autoplay: false,
            )
      ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s) {
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  if(product.hasStock)
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 8),
                      child: Consumer2<UserManager, Product>(
                    builder: (_, userManager, product, __){
                        return SizedBox(
                        height: 45,
                          child: RaisedButton(
                          onPressed: product.selectedSize != null ? (){
                            if(userManager.isLoggedIn){
                              context.read<CartManager>().addToCart(product);
                              Navigator.of(context).pushNamed('/cart');
                            }else {
                              Navigator.of(context).pushNamed('/login');
                            }
                          } : null,
                          color: primaryColor,
                          textColor: Colors.white,
                            child: Text(
                            userManager.isLoggedIn
                                ? 'Adicionar ao Carrinho'
                                : 'Entre para comprar',
                            style: const TextStyle(fontSize: 23),
                            ),
                          ),
                        );
                      },
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
