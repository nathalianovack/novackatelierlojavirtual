import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/models/order.dart';

class AdminOrderTile extends StatelessWidget {

  const AdminOrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final status = order.status;

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ExpansionTile(
          iconColor: primaryColor,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                    'Altere aqui o status do pedido',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: primaryColor,
                      fontSize: 14,
                    )
                ),
              ]
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2,),
                  Text(
                      'Status do Pedido',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 14,
                      )
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _status("1", "Preparação", status, 1),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _status("2", "Preparando para Envio", status, 2),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _status("3", "Entrega", status, 3),
                    ],
                  ),
                  const SizedBox(height: 6,),
                ],
              ),
            ),
            if(showControls)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FlatButton(
                    onPressed: (){

                    },
                    textColor: Colors.redAccent,
                    child: const Text('Cancelar Pedido'),
                  ),
                  FlatButton(
                    onPressed: (){},
                    textColor: Colors.black87,
                    child: const Text('Recuar Status'),
                  ),
                  FlatButton(
                    onPressed: (){},
                    textColor: Colors.black87,
                    child: const Text('Avançar Status'),
                  ),
                ],
              ),

            )
          ],
        )
    );
  }

  Widget _status(String title, String subtitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if(status == thisStatus){
      backColor = Colors.blueAccent;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.greenAccent;
      child = Icon(Icons.check, color: Colors.white,);
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
