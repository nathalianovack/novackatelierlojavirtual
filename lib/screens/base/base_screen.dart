import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:novackatelierlojavirtual/models/admin_orders_manager.dart';
import 'package:novackatelierlojavirtual/models/page_manager.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:novackatelierlojavirtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:novackatelierlojavirtual/screens/admin_users/admin_users_screen.dart';
import 'package:novackatelierlojavirtual/screens/contacts/contact_screen.dart';
import 'package:novackatelierlojavirtual/screens/home/home_screen.dart';
import 'package:novackatelierlojavirtual/screens/orders/orders_screen.dart';
import 'package:novackatelierlojavirtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();


  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return  PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),
              ContactScreen(),
              //verificando se o usuário é administrador
              if(userManager.adminEnabled)
                ...[
              AdminUsersScreen(),
              AdminOrdersScreen(),
              ],
            ]
          );
          },
      ),
    );
  }
}