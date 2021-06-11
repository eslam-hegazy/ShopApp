import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/cubit/register_cubit/states.dart';
import 'package:shopappwithapi/models/login_model.dart';
import 'package:shopappwithapi/network/end_points.dart';
import 'package:shopappwithapi/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialiteState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  LoginModel loginModel;

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data: {'name': name,'email': email, 'password': password,'phone': phone,}).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

   IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePassWordVisibilaty() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
