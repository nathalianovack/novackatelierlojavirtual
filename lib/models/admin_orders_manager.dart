import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:novackatelierlojavirtual/models/order.dart';
import 'package:novackatelierlojavirtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier{

  List<Order> _orders = [];

  User userFilter;

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}) {
    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  List<Order> get filteredOrders{
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }
    return output;
  }

  void _listenToOrders(){
    //procurar documentos no firebase
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      _orders.clear();
      for(final doc in event.documents){
        _orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  void setUserFilter(User user){
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();

  }
}