
class ResponseModel<T> {
  int code;
  String msg;
  T data;

  ResponseModel({required this.code,required this.data,required this.msg});

  ResponseModel.fromJson(Map<String, dynamic> m)
      : code = m['code'],
        msg = m['msg']??"",
        data = m['data'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'msg': msg,
        'data': data,
      };
}
