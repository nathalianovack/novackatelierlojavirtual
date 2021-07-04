class SectionItem {

  SectionItem({this.image, this.product});

  SectionItem.fromMap(Map<String,dynamic> map){
    //converter dados do firebase em objeto no código
    image = map['image'] as String;
    product = map['product'] as String;
  }

  dynamic image;
  String product;

  SectionItem clone(){
    return SectionItem(
      image: image,
      product: product,
    );
  }

  Map<String, dynamic> toMap()=> <String, dynamic> {
      'image': image,
      'product': product,
    };

  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}