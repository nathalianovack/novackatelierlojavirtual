import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Contatos'),
          centerTitle: true,
    ),
      body: Container(),
    );
  }
}
