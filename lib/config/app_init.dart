import 'package:base_app/util/cache_util.dart';

class AppInit{

  Future init()async{
    await CacheUtil().init();
  }
}