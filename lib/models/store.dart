import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novackatelierlojavirtual/models/address.dart';

class Store{

  Store.fromDocument(DocumentSnapshot doc) {
    name = doc.data['name'] as String;
    image = doc.data['image'] as String;
    phone = doc.data['phone'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
  }

  String name;
  String image;
  String phone;
  Address address;
  Map <String, Map> opening;

String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");

}