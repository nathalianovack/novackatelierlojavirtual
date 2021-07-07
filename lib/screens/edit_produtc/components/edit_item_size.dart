import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'package:novackatelierlojavirtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {

 const EditItemSize({Key key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown}) : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
 final VoidCallback onMoveUp;
 final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
          initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Tamanho',
                labelStyle: TextStyle(color: Colors.black87),
              isDense: true,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.brown
                    )
                )
            ),
            cursorColor: Colors.brown,
            validator: (name){
            if(name.isEmpty)
              return 'Inválido';
            return null;
            },
            onChanged: (name) => size.name = name,
        ),
        ),
        const SizedBox(width: 8,),
        Expanded(
          flex: 30,
          child: TextFormField(
          initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
                labelStyle: TextStyle(color: Colors.black87),
              isDense: true,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.brown
                    )
                )
            ),
            cursorColor: Colors.brown,
            validator: (stock){
            if(int.tryParse(stock) == null || stock.isEmpty)
              return 'Inválido';
            return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
            keyboardType: TextInputType.number,
        )
        ),
        const SizedBox(width: 8,),
        Expanded(
          flex: 40,
          child: TextFormField(
          initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              labelStyle: TextStyle(color: Colors.black87),
              isDense: true,
              prefixText: 'R\$  ',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.brown
                    )
                )
            ),
            cursorColor: Colors.brown,

            onChanged: (price) => size.price = num.tryParse(price),
            validator: (price){
            if(num.tryParse(price) == null || price.isEmpty)
              return 'Inválido';
            return null;
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        ),
        CustomIconButton(
          iconData: Icons.close_rounded,
          color: Colors.redAccent,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up_outlined,
          color: Theme.of(context).primaryColor,
          onTap: onMoveDown,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down_outlined,
          color: Theme.of(context).primaryColor,
          onTap: onMoveUp,
        ),
      ],
    );
  }
}
