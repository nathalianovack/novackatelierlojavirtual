import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'package:novackatelierlojavirtual/models/home_manager.dart';
import 'package:novackatelierlojavirtual/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    if(homeManager.editing){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    hintText: 'Digite aqui o Título da Seção',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                iconData: Icons.close_rounded,
                color: Colors.white,
                onTap: (){
                  homeManager.removeSection(section);
                },
              )
            ],
          ),
          if (section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                section.error,
                style: const TextStyle(
                  color: Colors.redAccent,
                // ver como fica  backgroundColor: Colors.grey,
                ),),
            )
        ],
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          section.name ?? "Nova Seção",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      );
    }

  }
}
