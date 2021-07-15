import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:novackatelierlojavirtual/models/order.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/address.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_product.dart';
import 'package:novackatelierlojavirtual/models/user.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:novackatelierlojavirtual/services/cepaberto_service.dart';
import 'package:novackatelierlojavirtual/models/product.dart';

class CartManager extends ChangeNotifier{

  CartManager cartManager;
  Order order;

  List<CartProduct> items = [];

  User user;
  Address address;

  num productPrices = 0.0;
  num deliveryPrice;

  num get totalPrice => productPrices + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){
    user = userManager.user;
    productPrices = 0.0;
    items.clear();
    removeAddress();

    if(user != null){
      _loadCartItems();
      _loadUserAddress();
    }

  }

  Future<void> _loadCartItems() async{
     final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

     items = cartSnap.documents.map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)).toList();
  }


  Future<void> _loadUserAddress() async {
    if(user.address != null && await calculateDelivery(user.address.lat, user.address.long)){
      //pegar o endereço do usuário e coloca no endereço para já calcular a entrega!
      address = user.address;
      notifyListeners();
    }
  }



  void addToCart(Product product){
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap()).then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  //limpando o carrinho após finalizar o pedido
  void clear(){
    for(final cartProduct in items){
      user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  void _onItemUpdated(){
    productPrices = 0.0;

    for(int i =0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productPrices += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct (CartProduct cartProduct){
    if(cartProduct.id != null)
    user.cartReference.document(cartProduct.id).updateData(cartProduct.toCartItemMap());

  }

  bool get isCartValid{
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  Future<void> getAddress(String cep) async{
    loading = true;

    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude
        );
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP Inválido, Tente novamente com outro CEP!');
    }
  }

  Future<void> setAddress(Address address) async{
    loading = true;

    this.address = address;
    
    if( await calculateDelivery(address.lat, address.long)){
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora área de Entrega :(\nEntre em contato pelo instagram @novackatelier\nOu pelo Whatsapp (41) 99965 - 8822');

    }

  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

   Future <bool> calculateDelivery(double lat, double long) async{
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final maxkm = doc.data['maxkm'] as num;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    
    double dis = await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    debugPrint('Distance $dis');

    if(dis > maxkm){
      return false;
    }
    deliveryPrice = base + dis * km;
    return true;
  }

  //CHECKOUT

  Future<void> checkout({Function onStockFail, Function onSuccess}) async{
    loading = true;
    try {
     await _decrementStock();
    }catch(e){
      onStockFail(e);
      loading = false;
      return;
    }
    // Gerar o número do pedido
    final orderId = await _getOrderId();

    final Order order = Order();
    order.orderId = orderId.toString();
    order.price = totalPrice;
    order.userId = user.id;
    order.status = 1;

    //salvar o pedido
    await order.save();

    await clear();

    onSuccess(order);
    loading = false;
  }


  Future<int> _getOrderId() async{
    final ref = firestore.document('aux/ordercounter');

    // ler e escrever valores consistentes no banco de dados.
  try {
    final result = await firestore.runTransaction((tx) async {
      //ler o documento order counter utilizando a transação
      final doc = await tx.get(ref);
      //atribuir o valor do pedido a variavel orderId
      final orderId = doc.data['current'] as int;
      //atualizar o valor do documento e adicionar mais 1
      // ignore: always_specify_types
      await tx.update(ref, <String, dynamic>{'current': orderId + 1});
      return { 'orderId': orderId};
    });
    return result['orderId'] as int;
  } catch(e){
    debugPrint(e.toString());
    return Future.error('Falha ao gerar número do pedido, tente novamente!');
  }

  }

  Future<void> _decrementStock(){
    // 1. Ler todos os estoques
    // 2. Decremento localmente os estoques
    // 3. Salvar os estoques no firebase

   return firestore.runTransaction((tx) async{

      //lista dos produtos que tem estoque
      final List<Product> productsToUpdate = [];
      //lista dos produtos que não tem estoque
      final List<Product> productsWithoutStock = [];

      for(final cartProdutc in items){
        Product product;

        //verificando se tem produtos iguais no carrinho
        if(productsToUpdate.any((p) => p.id == cartProdutc.productID)){
          product = productsToUpdate.firstWhere((p) => p.id == cartProdutc.productID);
        } else {
          //pegando a referencia do produto e colocando na variavel doc
          final doc = await tx.get(firestore.document('products/${cartProdutc.productID}'));
          //agora tem o produto mais atualizado
          product = Product.fromDocument(doc);
        }

        //colocar na tela do carrinho para mostrar qual item não tem estoque.
        cartProdutc.product = product;

        //obter o objeto tamanho correspondente ao tamanho que está no carrinho
        final size = product.findSize(cartProdutc.size);
        //verificar se o tamanho está disponivel no estoque
        if(size.stock - cartProdutc.quantity < 0){
          //adicionar o produto correspondente na lista dos produtos sem estoque
          productsWithoutStock.add(product);
        } else {
          //decrementar a quantidade do estoque
          size.stock -= cartProdutc.quantity;
          //adicionar o produto correspondente na lista dos produtos com estoque
          productsToUpdate.add(product);
        }
      }
      
      if(productsWithoutStock.isNotEmpty){
        //mostrar qual produto não tem estoque suficiente
        return Future<dynamic>.error('${productsWithoutStock.length} produtos sem estoque disponível!');
      }

      for(final product in productsToUpdate){
        //atualizar cada um dos produtos com os tamanhos atualizados
        tx.update(firestore.document('products/${product.id}'), <String, dynamic>{'sizes': product.exportSizeList()});
      }

    });
  }
}