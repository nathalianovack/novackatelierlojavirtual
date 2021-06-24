import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'package:novackatelierlojavirtual/models/item_size.dart';
import 'package:novackatelierlojavirtual/models/product.dart';
import 'package:novackatelierlojavirtual/screens/edit_produtc/components/edit_item_size.dart';


class SizesForm extends StatelessWidget {

  const SizesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
          initialValue: product.sizes,
          validator: (sizes){
            if(sizes.isEmpty)
              return 'Insira um tamanho';
            return null;
          },
          builder: (state) {
            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tamanhos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.playlist_add,
                      color: Theme.of(context).primaryColor,
                      onTap: (){
                        state.value.add(ItemSize());
                        state.didChange(state.value);
                      },
                    )
                  ],
                ),
                Column(
                  children: state.value.map((size) {
                    return EditItemSize(
                      key: ObjectKey(size),
                      size: size,
                      onRemove: (){
                        state.value.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveDown: size != state.value.first ? (){
                        final index = state.value.indexOf(size);
                        state.value.remove(size);
                        state.value.insert(index+1, size);
                        state.didChange(state.value);
                        } : null,
                      onMoveUp: size != state.value.last ? (){
                        final index = state.value.indexOf(size);
                        state.value.remove(size);
                        state.value.insert(index-1, size);
                        state.didChange(state.value);
                      } : null,
                    );
                  }).toList(),
                ),
                if(state.hasError)
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(state.errorText,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  )
              ],
            );
          }
          );
  }
}
