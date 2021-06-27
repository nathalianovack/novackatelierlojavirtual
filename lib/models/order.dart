import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novackatelierlojavirtual/models/address.dart';
import 'package:novackatelierlojavirtual/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/models/cart_product.dart';

class Order {



  //construtor para setar o cartManager
  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address as Address;
  }

  final Firestore firestore = Firestore.instance;

  //salvar os pedidos no firebase!
  Future<void> save() async{
    firestore.collection('orders').document(orderId).setData(
          {
            'items': items.map((e) => e.toOrderItemMap()).toList(),
            'price': price,
            'user': userId,
            'address': address.toMap(),
          }
        );
  }

  //salvar o número do pedido
  String orderId;

  //salvar a lista de produtos
  List<CartProduct> items;
  //salvar o preço total do pedido
  num price;
  //salvar o id do usuário que fez o pedido
  String userId;
  //salvar o endereço do usuário que fez o pedido
  Address address;
  //salvar a data que o usuário fez o pedido
  Timestamp date;

  Order({this.orderId, this.items, this.price, this.userId,
      this.address, this.date});
}
