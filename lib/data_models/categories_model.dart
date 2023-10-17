class CategoriesModel {

  late bool status;
  late String message;
  late CategoryList data;

  CategoriesModel(Map<String, dynamic> json) {

    status=json['status'];
    message=json['message'];
    if(json['data']!=null) {
      data=CategoryList.fromJson(json['data']);
    }





  }
}

class CategoryList{
 late int current_page;
 late List<Category> list=[];

  CategoryList.fromJson(Map<String , dynamic>json){
    current_page=json['current_page'];
    if(json['data']!=null) {
      json['data'].forEach((e){
        list.add(Category.fromJson(e));
      });
    }

  }




}
class Category{
 late int  id;
  late String name,image;

  Category.fromJson(Map<String,dynamic> json){

    id=json['id'];
    name=json['name'];
    image=json['image'];

  }


}


