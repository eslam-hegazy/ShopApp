import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/search_cubit/states.dart';
import 'package:shopappwithapi/models/search_model.dart';
import 'package:shopappwithapi/network/end_points.dart';
import 'package:shopappwithapi/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel model;
  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(url: SEARCH,token: token, data: {'text': text}).then((value) {
      model=SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      emit(SearchErrorState());
    });
  }
}
