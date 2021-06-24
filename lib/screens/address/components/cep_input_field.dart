import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/address.dart';
import 'file:///C:/Flutter/novackatelierlojavirtual/lib/models/cart_manager.dart';
import 'package:provider/provider.dart';


class CepInputField extends StatefulWidget {

  const CepInputField (this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primarycolor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if(widget.address.zipCode == null)

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12.345-678',
              ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep){
              if(cep.isEmpty)
                return 'Campo Obrigatório!';
              else if(cep.length != 10)
                return 'CEP Inválido!';
              return null;
            },
            ),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primarycolor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.loading ? () async {
              if(Form.of(context).validate()){
                try {
                 await context.read<CartManager>().getAddress(cepController.text);
                } catch (e) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$e',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300
                          ),),
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                      )
                  );
                }
              }
            }: null,
            color: primarycolor,
            disabledColor: primarycolor.withAlpha(100),
            child: const Text(
                'Buscar CEP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),),
          ),
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                  'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit_outlined,
              color: primarycolor,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
              size: 20,
            )

          ],
        ),
      );
  }
}
