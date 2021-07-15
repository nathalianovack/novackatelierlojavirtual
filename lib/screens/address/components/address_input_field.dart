import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/address.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {

  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    String emptyValidator(String text) => text.isEmpty? 'Campo Obrigatório' : null;

    if(address.zipCode != null && cartManager.deliveryPrice == null)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          enabled: !cartManager.loading,
          initialValue: address.street,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Rua/Avenida',
            labelStyle: TextStyle(color: Colors.black87),
            hintText: 'Rua XV de Novembro',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.brown
                  )
              )
          ),
          cursorColor: Colors.brown,
          validator: emptyValidator,
          onSaved: (t) => address.street = t,
        ),

        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                enabled: !cartManager.loading,
                initialValue: address.number,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Número',
                    labelStyle: TextStyle(color: Colors.black87),
                  hintText: '123',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.brown
                    )
                  )
                ),
                cursorColor: Colors.brown,
                inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: emptyValidator,
                onSaved: (t) => address.number = t,
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(
              child: TextFormField(
                enabled: !cartManager.loading,
                initialValue: address.complement,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Complemento',
                    labelStyle: TextStyle(color: Colors.black87),
                  hintText: 'Opcional',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown
                        )
                    )
                ),
                cursorColor: Colors.brown,
                onSaved: (t) => address.complement = t,
              ),
            ),
          ],
        ),
        TextFormField(
          enabled: !cartManager.loading,
          initialValue: address.district,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Bairro',
              labelStyle: TextStyle(color: Colors.black87),
            hintText: 'Centro',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.brown
                  )
              )
          ),
          cursorColor: Colors.brown,
          validator: emptyValidator,
          onSaved: (t) => address.district = t,
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextFormField(
                enabled: false,
                initialValue: address.city,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Cidade',
                    labelStyle: TextStyle(color: Colors.black87),
                  hintText: 'Curitiba',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown
                        )
                    )
                ),
                cursorColor: Colors.brown,
                validator: emptyValidator,
                onSaved: (t) => address.city = t,
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(
              child: TextFormField(
                autocorrect: false,
                enabled: false,
                textCapitalization: TextCapitalization.characters,
                initialValue: address.state,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Estado',
                    labelStyle: TextStyle(color: Colors.black87),
                  hintText: 'PR',
                  counterText: '',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown
                        )
                    )
                ),
                cursorColor: Colors.brown,
                maxLength: 2,
                validator: (e){
                  if(e.isEmpty){
                    return 'Campo Obrigatório';
                  } else if(e.length != 2){
                    return 'Inválido';
                  }
                  return null;
                },
                onSaved: (t) => address.state = t,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        if(cartManager.loading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
            backgroundColor: Colors.transparent,
          ),
        RaisedButton(
          onPressed: !cartManager.loading ? () async {
            if(Form.of(context).validate()){
              Form.of(context).save();
              try {
                await context.read<CartManager>().setAddress(address);
              } catch (e) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$e',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300
                    ),),
                    duration: const Duration(seconds: 20),
                    backgroundColor: Colors.red,
                  )
                );
              }
            }

          }: null,
          color: primaryColor,
          disabledColor: primaryColor.withAlpha(100),
          child: const Text(
              'Calcular Frete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),)
        ),
      ],
    );
    else if(address.zipCode != null)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
            '${address.street}, ${address.number}\n${address.district}\n'
                '${address.city} - ${address.state}'
        ),
      );
    else
      return Container();

  }
}
