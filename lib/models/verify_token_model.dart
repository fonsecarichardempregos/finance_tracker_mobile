class VerifyTokenModel {
  VerifyTokenModel();

  String? resetToken;
  String? message;


  VerifyTokenModel.fromJson(Map<String, dynamic> json) {
    resetToken = json['resetToken'];
    message = json['message'];
  }

  @override
  String toString() {
    return 'VerifyTokenModel{resetToken: $resetToken, message: $message}';
  }
}
