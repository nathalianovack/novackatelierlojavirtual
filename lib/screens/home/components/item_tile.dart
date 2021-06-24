import 'dart:io';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/models/home_manager.dart';
import 'package:novackatelierlojavirtual/models/product_manager.dart';
import 'package:novackatelierlojavirtual/models/section.dart';
import 'package:novackatelierlojavirtual/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:novackatelierlojavirtual/models/product.dart';

class ItemTile extends StatelessWidget {

  const ItemTile(this.item);

  final SectionItem item;


  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: (){
        if(item.product != null){
          final product = context.read<ProductManager>().findProductById(item.product);
            if(product != null){
              Navigator.of(context).pushNamed('/product', arguments: product);
            }
        }
      },
      onLongPress: homeManager.editing ? (){
        showDialog(
            context: context,
            builder: (_) {
              final product = context.read<ProductManager>().findProductById(item.product);
              return AlertDialog(
                title: const Text('Editar Item'),
                content: product != null
                    ? ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.network(product.images.first),
                      title: Text(product.name),
                      subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                )
                    : null,
                actions: <Widget>[
                  FlatButton(
                      onPressed: (){
                        context.read<Section>().removeItem(item);
                        Navigator.of(context).pop();
                  },
                      textColor: Colors.redAccent,
                      child: const Text('Excluir'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if(product != null){
                        item.product = null;
                      } else{
                      final Product produtc = await Navigator.of(context).pushNamed('/select_product') as Product;
                      item.product = produtc?.id;
                      }
                      Navigator.of(context).pop();
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      product != null
                        ? 'Desvincular'
                        : 'Vincular um Produto'),
                  ),
                ],
              );
            }
        );

      } : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.image as String,
              fit: BoxFit.cover,
          )
              : Image.file(item.image as File, fit: BoxFit.cover,),
      ),
    );
  }
}
