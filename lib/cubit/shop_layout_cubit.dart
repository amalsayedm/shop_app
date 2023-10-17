import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/shop_layout_states.dart';
import 'package:shopapp/data_models/categories_model.dart';
import 'package:shopapp/data_models/change_favourite_model.dart';
import 'package:shopapp/data_models/favourite_model.dart';
import 'package:shopapp/data_models/login_data_model.dart';
import 'package:shopapp/data_models/product_model.dart';
import 'package:shopapp/modules/categories_screen.dart';
import 'package:shopapp/modules/favourites_screen.dart';
import 'package:shopapp/modules/products_screen.dart';
import 'package:shopapp/modules/settings_screen.dart';
import 'package:shopapp/network/dio_helper.dart';
import 'package:shopapp/network/endpoints.dart';
import 'package:shopapp/shared/shared_components.dart';
import 'package:shopapp/shared/shared_pref_helper.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutStates> {

  List<Widget> screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),

  ];
  int navBarIndex = 0;
  late ProductModel productModel;
  late CategoriesModel categoriesModel;
  late FavouriteModel favouriteModel;
  late LoginModel profileModel;


  ShopLayoutCubit() : super(ShopLayoutInitialSate()) {
    getHomeData();
    getCategoriesData();
    getFavourite();
    getProfile();
  }


  static ShopLayoutCubit get(context) {
    return BlocProvider.of(context);
  }

  changeNavBarIndex(int index) {
    navBarIndex = index;
    emit(ShopLayoutChangeNavBarState());
  }

  void getHomeData() {
    emit(ShopLayoutHomeLoadingState());
    DioHelper.getData(path: HOME, lang: "en", token: token).then((value) {
      print(value.data);
      productModel = ProductModel(value.data);
      print(productModel.data?.products[0].name);
      emit(ShopLayoutHomeSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(ShopLayoutHomeErrorState());
    });
  }

  void getCategoriesData() {
    DioHelper.getData(path: CATEGORIES, lang: "en").then((value) {
      print(value.data);
      categoriesModel = CategoriesModel(value.data);
      emit(ShopLayoutCategoriesSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(ShopLayoutCategoriesErrorState());
    });
  }

  void updateFavourite({required int id,bool isFavourite=false}) {
    emit(ShopLayoutUpdateFavouriteLoadingState(id));
    bool ?helper;
    DioHelper.postData(path: FAVOURITE, data: {
      "product_id": id
    }, token: token).then((value) {
      print(value);
      ChangeFavouriteModel favmodel = ChangeFavouriteModel(value.data);
      if (favmodel.status) {
        productModel.data?.products.forEach((element) {
          if (element.id == id) {
            element.in_favorites = !element.in_favorites;
          }
        });
        if(isFavourite){
          favouriteModel.data.data.removeWhere((element){
            if(element.product.id==id){
             return helper!;
            }
            return false;
          });
        }
        emit(ShopLayoutUpdateFavouriteSuccessState());
        getFavourite();

      }
      else {
        toast(favmodel.message, Colors.red);
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(ShopLayoutUpdateFavouriteErrorState());
    });
  }

  void getFavourite() {

    DioHelper.getData(path: FAVOURITE, token: token).then((value) {
      print(value.data);
      favouriteModel = FavouriteModel(value.data);
      emit(ShopLayoutFavouriteSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(ShopLayoutFavouriteErrorState());
    });
  }

  void getProfile() {
    DioHelper.getData(path: PROFILE, token: token).then((value) {
      print(value.data);
      profileModel = LoginModel.fromJson(value.data);
      emit(ShopLayoutProfileSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(ShopLayoutProfileErrorState());
    });
  }

  void updateProfile(String name,String phone,String email) {
    emit(ShopLayoutUpdateProfileLoadingState());


    DioHelper.putData(path: UPDATE_PROFILE, token: token,
        data:{
          "name": name,
          "phone": phone,
          "email":email,

        } ).then((value) {
      print(value.data);
      if(value.data['status']){
        profileModel = LoginModel.fromJson(value.data);
        toast(profileModel.message, Colors.green);

        emit(ShopLayoutUpdateProfileSuccessState());
      }else{
        toast(profileModel.message, Colors.amber);

      }

    }).catchError((onError) {
      print(onError.toString());

      emit(ShopLayoutUpdateProfileErrorState());
      toast("Something went wrong", Colors.red);
    });
  }
}