import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:novackatelierlojavirtual/models/home_manager.dart';
import 'package:novackatelierlojavirtual/models/section.dart';
import 'package:novackatelierlojavirtual/screens/home/components/add_tile_widget.dart';
import 'package:novackatelierlojavirtual/screens/home/components/item_tile.dart';
import 'package:novackatelierlojavirtual/screens/home/components/seaction_header.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {

  //construtor
  const SectionStaggered(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {

    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
            Consumer<Section>(
              builder: (_, section, __){
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                  itemBuilder: (_, index){
                    if(index < section.items.length)
                      return ItemTile(section.items[index]);
                    else
                      return AddTileWidget();
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(2, 2),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
