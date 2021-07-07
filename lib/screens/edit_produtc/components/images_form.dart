import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/models/product.dart';
import 'package:novackatelierlojavirtual/screens/edit_produtc/components/image_souce_sheet.dart';

class ImagesForm extends StatelessWidget {

  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List<dynamic>.from(product.images),
      validator: (images){
        if(images.isEmpty)
          return 'Insira uma imagem!';
        return null;
      },
      onSaved: (images) => product.newImages = images,

      builder: (state){
        void onImageSelected(File file){
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Carousel(
                  images: state.value.map<Widget>((dynamic image){
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if(image is String)
                          Image.network(image, fit: BoxFit.cover,)
                        else
                          Image.file(image as File, fit: BoxFit.cover,),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close_rounded),
                            color: Colors.red,
                            onPressed: (){
                              state.value.remove(image);
                              state.didChange(state.value);

                            },
                          ),
                        )
                      ],
                    );
                  }).toList()..add(
                    Material(
                      color: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          color: Theme.of(context).primaryColor.withAlpha(120),
                          size: 60,
                        ),
                        onPressed: (){
                          showModalBottomSheet <void>(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              )
                          );
                        },
                      ),
                    )
                  ),
                  dotSize: 4,
                  dotSpacing: 16,
                  dotPosition: DotPosition.bottomCenter,
                  dotBgColor: Colors.white,
                  dotColor: Theme.of(context).primaryColor,
                  autoplay: false,
                )
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
      },
    );
  }
}
