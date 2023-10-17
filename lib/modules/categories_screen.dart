import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/shop_layout_cubit.dart';
import 'package:shopapp/cubit/shop_layout_states.dart';
import 'package:shopapp/data_models/categories_model.dart';
import 'package:shopapp/shared/shared_components.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit,ShopLayoutStates>(
         listener: (context,state){},builder: (context,state){
           ShopLayoutCubit c=ShopLayoutCubit.get(context);
           return ConditionalBuilder(condition: c.categoriesModel!=null,
               builder: (context){
             return ListView.separated(
                 itemBuilder: (context,int index){
                   return buildListItem(c.categoriesModel.data.list[index]);
                 },
                 separatorBuilder: (context,int index){
                   return Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: divider(),
                   );
                 },
                 itemCount: c.categoriesModel.data.list.length);
               },
           fallback: (context){
             return Center(child: CircularProgressIndicator());

           });
    },);
  }

 Widget buildListItem(Category category){
   return Padding(
     padding: const EdgeInsets.all(20),
     child: Row(children: [
       Image(image: NetworkImage(category.image),width: 100,height: 100,),
       SizedBox(width: 10,),
       Text(category.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
       Spacer(),
       Icon(Icons.arrow_forward_ios),
     ],),
   );
  }
}
