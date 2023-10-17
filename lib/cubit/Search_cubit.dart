import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/Search_states.dart';
import 'package:shopapp/data_models/search_model.dart';
import 'package:shopapp/network/dio_helper.dart';
import 'package:shopapp/network/endpoints.dart';
import 'package:shopapp/shared/shared_components.dart';

class SearchCubit extends Cubit<SearchStates>{


  late  SearchModel searchModel;
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) {
    return BlocProvider.of(context);
  }

  void getSearchResult(String text) {

    emit(SearchLoadingState());
    DioHelper.postData(path:SEARCH, token: token,
        data:{
          "text": text,
        } ).then((value) {
      print(value.data);
      if(value.data['status']){
        searchModel = SearchModel(value.data);

        emit(SearchSuccessState());
      }else{
        toast(searchModel.message, Colors.amber);

      }

    }).catchError((onError) {
      print(onError.toString());

      emit(SearchErrorState());
      toast("Something went wrong", Colors.red);
    });
  }


}