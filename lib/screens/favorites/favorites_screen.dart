import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';

import '../../cubit/shop_app_cubit/shop_app_cubit.dart';

import '../../cubit/shop_app_cubit/shop_app_states.dart';
import '../../models/favorites_model.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) => ConditionalBuilder(
              condition: state is! ShopLoadingGetFavoriteState,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) => buildListProducts(
                      ShopCubit.get(context).favoritesModel.data.data[index].product,
                      context),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      ShopCubit.get(context).favoritesModel.data.data.length),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
        listener: (context, state) {});
  }

  }
