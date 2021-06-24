import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  ImageSourceSheet({this.onImageSelected});

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  Future<void> editImage(String path, BuildContext context) async{
   final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarTitle: 'Editar Imagem',
            toolbarWidgetColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          cropFrameColor: Colors.white,
        )
    );
   if(croppedFile != null){
     onImageSelected(croppedFile);
   }
  }

  @override
    Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: Theme.of(context).primaryColor,
        onClosing: (){},
        elevation: 10,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
                onPressed: () async {
                  final PickedFile file = await picker.getImage(source: ImageSource.camera);
                  editImage(file.path, context);

                },
                child: Text('Abrir a Câmera',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),),
            ),
            FlatButton(
              onPressed: () async {
                final PickedFile file = await picker.getImage(source: ImageSource.gallery);
                editImage(file.path, context);

              },
              child: Text('Buscar na Galeria',
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 24,
                 fontWeight: FontWeight.w300,
              ),
              ),
            ),
          ],
        )
    );
  }
}
