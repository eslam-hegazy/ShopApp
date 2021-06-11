import 'package:shopappwithapi/models/change_favorite_model.dart';
import 'package:shopappwithapi/models/login_model.dart';

abstract class ShopStates {}

class ShopInitializeState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopSuccessChangeFavoriteState extends ShopStates {
  final ChangeFavoriteModel changeFavoriteModel;

  ShopSuccessChangeFavoriteState(this.changeFavoriteModel);
}

class ShopChangeFavoriteState extends ShopStates {}

class ShopErrorChangeFavoriteState extends ShopStates {}

class ShopLoadingGetFavoriteState extends ShopStates {}

class ShopSuccessGetFavoriteState extends ShopStates {}

class ShopErrorGetFavoriteState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final LoginModel loginModel;
  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}
class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates {
  final LoginModel loginModel;
  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}
