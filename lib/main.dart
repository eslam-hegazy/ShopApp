import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/shop_app_cubit/shop_app_cubit.dart';
import 'package:shopappwithapi/my_bloc_observer.dart';
import 'package:shopappwithapi/network/local/cache_helper.dart';
import 'package:shopappwithapi/screens/login_screen.dart';
import 'package:shopappwithapi/screens/onboarding_screen.dart';
import 'package:shopappwithapi/screens/shop_layout.dart';

import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

  Widget widget;
  if (onBoarding != null) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }
  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  final Widget widget;
  MyApp(this.widget);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => ShopCubit()
              ..getHomeData()
              ..getCategories()
              ..getFavorite()
              ..getUserData())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget,
      ),
    );
  }
}
