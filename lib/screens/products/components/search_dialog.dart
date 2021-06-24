import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog(this.initialText);

  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 5,
          left: 10,
          right: 10,
          child: Card(
            child: TextFormField(
              initialValue: initialText,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back_outlined, color: Theme.of(context).primaryColor,),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ),
              onFieldSubmitted: (text){
                Navigator.of(context).pop(text);
              },

            ),
          ),
        )
      ],
    );
  }
}
