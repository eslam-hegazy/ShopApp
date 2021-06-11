import 'dart:ui';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_cubit.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopappwithapi/models/categories_model.dart';
import 'package:shopappwithapi/models/home_model.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(builder: (context, state) {
      return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context),
          fallback: (context) => Center(child: CircularProgressIndicator()));
    }, listener: (context, state) {
      if (state is ShopSuccessChangeFavoriteState) {
        if (!state.changeFavoriteModel.status) {
          showToast(
              text: state.changeFavoriteModel.message,
              state: ToastStates.ERROR);
        }
      }
    });
  }

  Widget productsBuilder(HomeModel homeModel, CategoriesModel categoriesModel,
       context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
              items: homeModel.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                  height: 250,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal)),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  'categories',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel.data.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10.0,
                          ),
                      itemCount: categoriesModel.data.data.length),
                ),
                Text(
                  'New Products',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              mainAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.75,
              crossAxisSpacing: 1.0,
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                  homeModel.data.products.length,
                  (index) => buildGirdProduct(
                      homeModel.data.products[index], context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGirdProduct(ProductsModel model, context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                height: 200.0,
                image: NetworkImage(model.image),
                width: double.infinity,
              ),
              if (model.discount != 0)
                Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                      ),
                    ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.0, height: 1.3),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: TextStyle(fontSize: 12.0, color: Colors.blue),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if (model.discount != 0)
                      Text('${model.old_price.round()}',
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough)),
                    Spacer(),
                    CircleAvatar(
                      radius: 15.0,
                      backgroundColor:
                          ShopCubit.get(context).favorites[model.id]
                              ? Colors.red
                              : Colors.grey,
                      child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ShopCubit.get(context).changeFavorites(model.id);
                          }),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoryItem(DataModel dataModel) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(dataModel.image),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
              width: 100.0,
              color: Colors.black.withOpacity(0.8),
              child: Text(dataModel.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  )))
        ],
      );
}
