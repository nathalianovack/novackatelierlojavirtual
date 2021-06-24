// O LOGIN CARD É PARA MOSTRAR AO USUÁRIO QUE ELE NÃO ESTÁ LOGADO QUANDO SOLICITA PARA VER O CARRINHO OU MEUS PEDIDOS. 
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Faça login para acessar seu carrinho!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed('/login');
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: const Text(
                      'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 2,
                  ),
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}