
class Article{

  int id, item;
  String name, shop, image;

  var price;

  Article();

  // convert map to object
  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.item = map['item'];
    this.price = map['price'];
    this.shop = map['shop'];
    this.image = map['image'];
  }

  // convert object to map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': this.name,
      'item': this.item,
      'shop': this.shop,
      'price': this.price,
      'image': this.image,
    };

    if(this.id!=null){
      map['id'] = this.id;
    }

    return map;
  }
}