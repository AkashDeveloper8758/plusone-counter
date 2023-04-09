// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponseType<T> {
  final bool status;
  final T? data;
  final String message;
  ResponseType({
    required this.status,
    this.data,
    required this.message,
  });
}
