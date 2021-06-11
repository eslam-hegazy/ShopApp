import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/cubit/login_cubit/states.dart';
import 'package:shopappwithapi/models/login_model.dart';
import 'package:shopappwithapi/network/end_points.dart';
import 'package:shopappwithapi/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialiteState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);
  LoginModel loginModel;

  void userLogin({@required String email, @required String password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(url: LOGIN, data: {'email': email, 'password': password})
        .then((value) {
     
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePassWordVisibilaty() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}
