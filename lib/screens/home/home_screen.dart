import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novackatelierlojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:novackatelierlojavirtual/models/home_manager.dart';
import 'package:novackatelierlojavirtual/models/user_manager.dart';
import 'package:novackatelierlojavirtual/screens/home/components/add_section_widget.dart';
import 'package:novackatelierlojavirtual/screens/home/components/section_list.dart';
import 'package:novackatelierlojavirtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const[
                  Color.fromARGB(255, 160, 100, 110),
                  Color.fromARGB(225, 163, 130, 135),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Novack Atelier'),
                centerTitle: true,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pushNamed('/cart'),
                ),
                Consumer2<UserManager, HomeManager>(
                  builder: (_, userManager, homeManager, __){
                    if(userManager.adminEnabled && !homeManager.loading){
                      if(homeManager.editing){
                        return PopupMenuButton(
                          elevation: 80,
                          color: Theme.of(context).primaryColor,
                          onSelected: (e){
                            if(e == 'Salvar'){
                              homeManager.saveEditing();
                            } else {
                              homeManager.discardEditing();
                            }
                          },
                            itemBuilder: (_){
                              return ['Salvar','Descartar'].map((e){
                                return PopupMenuItem(
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25,
                                    ) ,),
                                  value: e,
                                );
                              }).toList();
                            }
                        );
                      }else {
                        return IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: homeManager.enterEditing,
                        );
                      }
                    }else
                      return Container();
                  },
                )
              ],
            ),
            Consumer<HomeManager>(
              builder: (_, homeManager, __){
                if(homeManager.loading){
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
                //transformar cada seção em Widget
                final List<Widget> children = homeManager.sections.map<Widget>(
                        (section) {
                          //verificando o tipo de seção
                          switch(section.type){
                            case 'List':
                              return SectionList(section);
                            case 'Staggered' :
                              return SectionStaggered(section);
                            default:
                              return Container();
                          }
                        }
                ).toList();

                if(homeManager.editing)
                  children.add(AddSectionWidget(homeManager));


                return SliverList(
                    delegate: SliverChildListDelegate(children),
                );
              },
            )
          ],
        ),
      ],
      ),
    );
  }
}
