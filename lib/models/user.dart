import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/address.dart';

class User {

  User({this.email, this.password, this.name, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    if(document.data.containsKey('address')){
      address = Address.fromMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  bool admin = false;

  Address address;

  DocumentReference get firestoreRef =>
      Firestore.instance.document('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }
  Map<String, dynamic> toMap()=> <String, dynamic>{
      'name': name,
      'email': email,
      if(address != null)
        'address' : address.toMap(),
    };

  void setAddress(Address address) async{
    this.address = address;
    saveData();
  }
}