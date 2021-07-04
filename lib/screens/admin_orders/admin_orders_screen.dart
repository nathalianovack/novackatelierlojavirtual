import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/admin_order_tile.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'package:novackatelierlojavirtual/common/empty_card.dart';
import 'package:novackatelierlojavirtual/models/admin_orders_manager.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Painel de Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, adminOrdersManager, __){
          final filteredOrders = adminOrdersManager.filteredOrders;

          return Column(
            children: [
              if(adminOrdersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pedidos de ${adminOrdersManager.userFilter.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: (){
                          adminOrdersManager.setUserFilter(null);
                        },
                      )
                    ],
                  ),
                ),
              if(filteredOrders.isEmpty)
                Expanded(
                    child: EmptyCard(
                  title: 'Nenhuma venda realizada!',
                  iconData: Icons.border_clear_outlined,
                  )
                )
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, int index){
                        return AdminOrderTile(
                          filteredOrders[index],
                          showControls: true,
                        );
                      }
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
