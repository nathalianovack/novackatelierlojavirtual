import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_icon_button.dart';
import 'package:novackatelierlojavirtual/models/store.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {

  const StoreCard(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {


    void openPhone(){
      launch('tel:${store.cleanPhone}');
    }

    final Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(store.image, fit: BoxFit.cover,),
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            store.name,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12,),
                          const Text(
                            'Localização: Curitiba - Paraná\nHorário de Funcionamento: 09:00 - 19:00\nEm caso de dúvidas entre em contato!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          iconData: Icons.phone_outlined,
                          color: primaryColor,
                          size: 50,
                          onTap: openPhone,
                        ),
                        Text(
                          store.phone,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                        )
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
