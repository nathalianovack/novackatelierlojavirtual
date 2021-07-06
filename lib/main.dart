import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/models/admin_orders_manager.dart';
import 'package:novackatelierlojavirtual/models/admins_user_manager.dart';
import 'package:novackatelierlojavirtual/models/home_manager.dart';
import 'package:novackatelierlojavirtual/models/order.dart';
import 'package:novackatelierlojavirtual/models/orders_manager.dart';
import 'package:novackatelierlojavirtual/models/product_manager.dart';
import 'package:novackatelierlojavirtual/models/stores_manager.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/screens/address/address_screen.dart';
import 'package:novackatelierlojavirtual/screens/cart/cart_screen.dart';
import 'package:novackatelierlojavirtual/screens/confirmation/confirmation_screen.dart';
import 'package:novackatelierlojavirtual/screens/edit_produtc/edit_product_screen.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/screens/base/base_screen.dart';
import 'package:novackatelierlojavirtual/screens/login/login_screen.dart';
import 'package:novackatelierlojavirtual/screens/product/product_screen.dart';
import 'package:novackatelierlojavirtual/screens/select_product/select_product_screen.dart';
import 'package:novackatelierlojavirtual/screens/signup/signup_screen.dart';
import 'package:novackatelierlojavirtual/models/product.dart';
import 'package:provider/provider.dart';
import 'models/user_manager.dart';

void main() {
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
    ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
    ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) => cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager> (
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) => ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (_) => StoresManager()
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) => adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
            update: (_, userManager, adminOrdersManager) => adminOrdersManager..updateAdmin(adminEnabled: userManager.adminEnabled),
        )
      ],
      child: MaterialApp(
        title: 'Novack Atelier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 160, 100, 110),
          scaffoldBackgroundColor: const Color.fromARGB(255, 160, 100, 110),
          appBarTheme: const AppBarTheme(
              elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => LoginScreen()
              );
            case '/edit_product':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => EditProductScreen(settings.arguments as Product)
              );
            case '/signup':
              return MaterialPageRoute<dynamic> (
                  builder: (_) => SignUpScreen()
              );
            case '/select_product':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => SelectProductScreen()
              );
            case '/confirmation':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => ConfirmationScreen(settings.arguments as Order)
              );
            case '/cart':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => CartScreen(),
                settings: settings
              );
            case '/address':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => AddressScreen()
              );
            case '/product':
              return MaterialPageRoute<dynamic>(
                  builder: (_) => ProductScreen(settings.arguments as Product)
              );
            case '/':
            default:
              return MaterialPageRoute<dynamic>(
                  builder: (_) => BaseScreen(),
                settings: settings
              );
          }
        },
      ),
    );
  }
}