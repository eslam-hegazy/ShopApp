import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_cubit.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_states.dart';
import 'package:shopappwithapi/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) => ListView.separated(
            itemBuilder: (context, index) => buildCatItem(
                ShopCubit.get(context).categoriesModel.data.data[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: ShopCubit.get(context).categoriesModel.data.data.length),
        listener: (context, state) {});
  }

  Widget buildCatItem(DataModel model) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Image(
            image: NetworkImage(model.image),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(model.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
