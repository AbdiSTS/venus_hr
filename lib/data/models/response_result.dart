class ResponseResult {
  final bool success;
  final String message;
  final List<dynamic> data;

  ResponseResult({
    this.success = false,
    this.message = '',
    this.data = const [],
  });
}
