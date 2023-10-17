import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/shop_layout_cubit.dart';
import 'package:shopapp/cubit/shop_layout_states.dart';
import 'package:shopapp/data_models/categories_model.dart';
import 'package:shopapp/data_models/product_model.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit,ShopLayoutStates>(
         listener: (context,state){},
      builder: (context,state){
           ShopLayoutCubit cubit=ShopLayoutCubit.get(context);
           return ConditionalBuilder(condition: cubit.productModel!=null && cubit.categoriesModel!=null,
               builder: (context){
             return productBuilder(cubit);
               },
           fallback: (context){
             return Center(child: CircularProgressIndicator());
           },);
      },);
  }


  Widget productBuilder(ShopLayoutCubit cubit){
    return SingleChildScrollView(
      child: Column(
        children: [
        CarouselSlider(items:
          cubit.productModel.data!.banners.map((e) =>Image(image: NetworkImage(e.image),
           width: double.infinity,fit: BoxFit.cover,) ).toList() ,
            options: CarouselOptions(viewportFraction: 1.0,
                height: 250,initialPage: 0,enableInfiniteScroll: true,
            reverse: false,autoPlay:true,autoPlayInterval:const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds:1),autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Categories",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              SizedBox(height: 10,),

              Container(height: 100,
                child: ListView.separated(physics:BouncingScrollPhysics(),scrollDirection: Axis.horizontal,
                itemBuilder: (context,int index){
                  return buildCategoryItem(cubit.categoriesModel.data.list[index]);
                }, separatorBuilder: (context,int index){
                  return SizedBox(width: 10,);
    }, itemCount: cubit.categoriesModel.data.list.length),
              ),
          SizedBox(height: 10,),
              Text("New Products ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: GridView.count(shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,crossAxisSpacing: 3,mainAxisSpacing:3,childAspectRatio:1/1.55 ,
              children:
              List.generate(cubit.productModel.data!.products.length, (index) {
                return buildGridItem(cubit.productModel.data!.products[index],cubit);
              })
            ,),
          ),
        ),
      ],),
    );
  }

  Widget buildGridItem(Product product,ShopLayoutCubit cubit){

    return Container(color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Stack(alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(image: NetworkImage(product.image),width: double.infinity,
              height: 200,),

            if(product.discount!=0)
            Container(color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Discount",style: TextStyle(color: Colors.white),),
                ))
          ],
        ),

          Padding(
            padding: const EdgeInsetsDirectional.only(top: 5,start: 5,end: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  children: [
                    Row(children: [
                      Text(product.price.toString(),style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      if(product.discount!=0)
                        Text(product.old_price.toString(),style: TextStyle(color: Colors.grey,decoration: TextDecoration.lineThrough),),

                    ],),
                    Spacer(),
                    (cubit.state is ShopLayoutUpdateFavouriteLoadingState && (cubit.state as ShopLayoutUpdateFavouriteLoadingState).id==product.id)?
                    IconButton(iconSize: 10,
                      icon:CircularProgressIndicator(strokeWidth: 2,)
                      ,onPressed: (){
                    },):IconButton(
                      icon:
                      CircleAvatar(radius: 15,
                          backgroundColor: product.in_favorites?Colors.deepOrange:Colors.grey,
                          child: Icon(Icons.favorite_outline,size: 14,color: Colors.white,))
                      ,onPressed: (){
                      cubit.updateFavourite(id:product.id);
                    },),

                  ],
                ),
              ],
            ),
          ),
       // SizedBox(height: 5,),

      ],),
    );

  }

  Widget buildCategoryItem(Category category){
    return Stack(alignment: AlignmentDirectional.bottomCenter,
      children: [
      Image(image: NetworkImage(category.image),height: 100,width: 100,fit: BoxFit.cover,),
      Container(width:100,color: Colors.black.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(category.name,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.white,),),
        ),),
    ],);
  }
}
