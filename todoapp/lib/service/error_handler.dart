class ErrorModel {
  final bool success;
  String message;
  final dynamic data;
  ErrorModel({
    this.data,
    required this.message,
    required this.success,
  });

  factory ErrorModel.fromJson({required Map<String, dynamic> json}) {
    return ErrorModel(
        success: json['success'], message: json['message'], data: json['data']);
  }
}
