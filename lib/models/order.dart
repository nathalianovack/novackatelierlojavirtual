import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novackatelierlojavirtual/models/address.dart';
import 'package:novackatelierlojavirtual/models/cart_manager.dart';
import 'package:novackatelierlojavirtual/models/cart_product.dart';
import 'cart_product.dart';

//enum Status{canceled, preparing, transporting, delivered}

class Order {

  CartManager cartManager;
  CartProduct cartProduct;

  /*//construtor para setar o cartManager
  // ignore: missing_return
  Order order (CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address as Address;
    status = Status.preparing;
  }
*/
  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.documentID;
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    date = doc.data['date'] as Timestamp;
    status = doc.data['status'] as int;
    //status = Status.values[doc.data['status'] as int];
  }

  final Firestore firestore = Firestore.instance;

  //salvar os pedidos no firebase!
  Future<void> save() async{
    firestore.collection('orders').document(orderId).setData(
        <String, dynamic>{
            'items': items,
            'price': price,
            'user': userId,
            'address': address,
            'status': status,
            'date': Timestamp.now()
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

  int status;

//  Status status;

//formatar o número do pedido na página Meus pedidos
  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get formattedDate => '';

  Order(
      {
        this.orderId,
        this.items,
        this.price,
        this.userId,
        this.address,
        this.date,
        this.status,
      }
  );

  @override
  String toString() {
    return 'Order{cartManager: $cartManager, cartProduct: $cartProduct, firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
