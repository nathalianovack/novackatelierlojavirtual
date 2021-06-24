import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/models/product.dart';
import 'package:novackatelierlojavirtual/models/product_manager.dart';
import 'package:novackatelierlojavirtual/screens/edit_produtc/components/images_form.dart';
import 'package:novackatelierlojavirtual/screens/edit_produtc/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {

  EditProductScreen(Product p) :
        editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                          hintText: 'Digite o Título do Produto',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                      ),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (name){
                        if(name.length < 6)
                          return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Digite aqui a descrição do Produto',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      maxLines: null,
                      validator: (desc){
                        if(desc.length < 6 )
                          return 'Descrição muito curta!';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    const SizedBox(height: 5,),
                    SizesForm(product),
                    const SizedBox(height: 20,),
                    Consumer<Product>(
                        builder: (_, product, __){
                          return SizedBox(
                            height: 45,
                            child: RaisedButton(
                              onPressed: !product.loading ? () async{
                                if(formKey.currentState.validate()){
                                  formKey.currentState.save();

                                  await product.save();

                                  context.read<ProductManager>().update(product);

                                  Navigator.of(context).pop();
                                }
                              } : null,
                              child: product.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ) : const Text('Salvar alterações',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),),
                              color: primaryColor,
                              disabledColor: primaryColor.withAlpha(100),
                            ),
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

