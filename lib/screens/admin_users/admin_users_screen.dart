import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:novackatelierlojavirtual/models/admin_orders_manager.dart';
import 'package:novackatelierlojavirtual/models/admins_user_manager.dart';
import 'package:novackatelierlojavirtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager,__){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  adminUsersManager.users[index].name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
              ),
                subtitle: Text(
                  adminUsersManager.users[index].email,
                  style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
          ),
                onTap: (){
                  context.read<AdminOrdersManager>().setUserFilter(
                    adminUsersManager.users[index]
                  );
                  context.read<PageManager>().setPage(5);
                },
              );
          },
            highlightTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.w900,
            ),
            normalTextStyle: TextStyle(
              color: Colors.black45,
              fontSize: 25,
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        },
      )
      );
  }
}
