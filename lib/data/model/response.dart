class ResponseModel {
  ResponseModel(this._isSuccess, this._message, {this.data});
  final bool _isSuccess;
  final String _message;
  dynamic data;

  bool get isSuccess => _isSuccess;
  String? get message => _message;
  dynamic get body => data;
}
