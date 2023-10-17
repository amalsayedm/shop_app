class LoginModel {

  late bool status;
  late String message;
  late UserData data;

  LoginModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    if(json['data']!=null){
      data=UserData.fromJson(json['data']);
    }
  }
}

class UserData{

  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late int points;
  late int credit;
  late String token;

  UserData(this.id, this.name, this.email, this.phone, this.image, this.points,
      this.credit, this.token);

  UserData.fromJson(Map<String,dynamic> data){
    this.id=data['id'];
    this.name=data['name'];
    this.email=data['email'];
    this.phone=data['phone'];
    this.image=data['image'];
    this.points=data['points'];
    this.credit=data['credit'];
    this.token=data['token'];

  }
}