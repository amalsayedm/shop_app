import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/login_states.dart';
import 'package:shopapp/data_models/login_data_model.dart';
import 'package:shopapp/network/dio_helper.dart';
import 'package:shopapp/network/endpoints.dart';
import 'package:shopapp/shared/shared_components.dart';
import 'package:shopapp/shared/shared_pref_helper.dart';

class LoginCubit extends Cubit<LoginStates>{

  IconData passwordSuffixIcon=Icons.visibility_off;
  bool obscure=true;
  late LoginModel loginModel;

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context){
   return BlocProvider.of(context);
  }

  void changePasswordVisibility(){
    obscure=!obscure;
    passwordSuffixIcon=obscure?Icons.visibility_off:Icons.visibility;

    emit(LoginPasswordVisibilityChangedState());
  }
  void login({@required email,@required password}){
    emit(LoginLoadingState());
    print("'email $email +password $password ");
    DioHelper.postData(path: LOGIN, data: {
      'email':'$email',
      'password':'$password',
    }).then((value){
      print(value.data);
      loginModel=LoginModel.fromJson(value.data);
      print(loginModel.message);
     // print(loginModel.data.name);
      emit(LoginSuccessState(loginModel));
    }).catchError((onError){
      print(onError.toString());

      emit(LoginErrorState(onError.toString()));

    });

  }

  void register(String name,String phone,String email,String password){

    emit(RegisterLoadingState());

    DioHelper.postData(path: REGISTER, data: {
      'email':email,
      'password':password,
      'name':name,
      'phone':phone
    }).then((value){
      print(value.data);
      if(value.data['status']){
        SharedPrefHelper.saveString(key: "token", value:value.data['data']['token']).
        then((bool){
          token=value.data['data']['token'];
        });

      toast("User Registered Successfully", Colors.green);
    }else{
        toast(value.data['message'], Colors.amber );

      }
      emit(RegisterSuccessState(value.data['status']));
    }).catchError((onError){
      print(onError.toString());
      toast(onError.toString(), Colors.red);

      emit(RegisterErrorState());

    });
  }

}