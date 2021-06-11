import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_states.dart';
import 'package:shopappwithapi/models/categories_model.dart';
import 'package:shopappwithapi/models/change_favorite_model.dart';
import 'package:shopappwithapi/models/home_model.dart';
import 'package:shopappwithapi/models/login_model.dart';
import 'package:shopappwithapi/network/end_points.dart';
import 'package:shopappwithapi/network/remote/dio_helper.dart';
import 'package:shopappwithapi/screens/categories/categories_screen.dart';
import 'package:shopappwithapi/screens/favorites/favorites_screen.dart';
import 'package:shopappwithapi/screens/products/products_screen.dart';
import 'package:shopappwithapi/screens/settings/settings_screen.dart';

import '../../models/favorites_model.dart';
import '../../network/end_points.dart';
import 'shop_app_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitializeState());

  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  Map<int, bool> favorites = {};
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({element.id: element.in_favorites});
      });
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(url: GET_CATEGORIES, token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoriteModel changeFavoriteModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoriteState());
    DioHelper.postData(
        url: FAVORITES,
        token: token,
        data: {'product_id': productId}).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (!changeFavoriteModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorite();
      }
      emit(ShopSuccessChangeFavoriteState(changeFavoriteModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];

      emit(ShopErrorChangeFavoriteState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorite() {
    emit(ShopLoadingGetFavoriteState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoriteState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoriteState());
    });
  }

  LoginModel userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userModel = LoginModel.fromJson(value.data);

      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
        url: UPDATEPROFILE,
        token: token,
        data: {'name': name, 'email': email, 'phone': phone}).then((value) {
      userModel = LoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
