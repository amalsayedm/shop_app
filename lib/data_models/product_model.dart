class ProductModel{

  late bool status;
  late String message;
   ProductData? data;

  ProductModel(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    data=json!=null?ProductData(json['data']):null;

  }
}

class ProductData {
  List<Banner> banners = [];
  List<Product>products = [];

  ProductData(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      json['banners'].forEach((element) {
        banners.add(Banner.fromJson(element));
      });

      if (json['products'] != null) {
        json['products'].forEach((element) {
          products.add(Product.fromJson(element));
        });
      }

    }
  }
}

class Banner{
  late int id;
  late String image,category,product;

  Banner.fromJson(Map<String,dynamic> json){
    id=json['id'];
    image=json['image'];
    category=json['category'];
    product=json['product'];

  }


}

class Product{

  late int id;
  late  dynamic price,old_price,discount;
  late  String image,name;
  late bool in_favorites,in_cart;


  Product.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    in_cart=json['in_cart'];
    in_favorites=json['in_favorites'];
    image=json['image'];
    name=json['name'];
    discount=json['discount'];
    old_price=json['old_price'];

  }


}

