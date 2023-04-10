class LoginArgs {
  String phone;
  LoginArgs({
    required this.phone,
  });
}

class ApiResponseStatus {
  bool status;
  String message; //Just for testing
  ApiResponseStatus({
    required this.status,
    required this.message,
  });
}
