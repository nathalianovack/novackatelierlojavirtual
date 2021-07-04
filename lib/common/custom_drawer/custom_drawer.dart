import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/drawer_tile.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
               colors: [const Color.fromARGB(208, 219, 144, 160),
               Colors.white,
               ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              const DrawerTile(
                iconData: Icons.home_outlined,
                title: 'Inicio',
                page: 0,),
              const DrawerTile(
                iconData: Icons.format_list_bulleted_outlined,
                title: 'Produtos',
                page: 1,),
              const DrawerTile(
                iconData: Icons.shopping_bag_outlined,
                title: 'Meus Pedidos',
                page: 2,),
              const DrawerTile(
                iconData: Icons.contact_support_outlined,
                title: 'Contatos',
                page: 3  ,
              ),
              //habilitando itens de adminitradores do app
              Consumer<UserManager>(
                builder: (_, userManager, __){
                  if(userManager.adminEnabled){
                    return Column(
                      children: <Widget>[
                        const Divider(),
                        const DrawerTile(
                          iconData: Icons.people_alt_outlined,
                          title: 'Usuários',
                          page: 4,),
                        const DrawerTile(
                          iconData: Icons.analytics_outlined,
                          title: 'Painel Pedidos',
                          page: 5  ,
                        ),
                      ],
                    );
                    } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
