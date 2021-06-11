class ChangeFavoriteModel {
  bool status;
  String message;
  ChangeFavoriteModel.fromJson(Map<String, Object> json) {
    status = json['status'];
    message = json['message'];
  }
}
