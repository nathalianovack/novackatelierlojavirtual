import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:novackatelierlojavirtual/common/empty_card.dart';
import 'package:novackatelierlojavirtual/common/login_card.dart';
import 'package:novackatelierlojavirtual/models/orders_manager.dart';
import 'package:novackatelierlojavirtual/common/order_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.user == null){
            return LoginCard();
          }
          if(ordersManager.orders.isEmpty){
            return EmptyCard(
              title: 'Nenhuma compra efetuada!',
              iconData: Icons.border_clear_outlined,
            );
          }
          return ListView.builder(
              itemCount: ordersManager.orders.length,
              itemBuilder: (_, int index){
                return OrderTile(
                  ordersManager.orders.reversed.toList()[index]
                );
              }
          );
        },
      ),
    );
  }
}
