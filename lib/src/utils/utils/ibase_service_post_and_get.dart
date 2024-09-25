import 'package:componentes_lr/src/utils/utils/ibase_service_get.dart';

abstract class IBaseServicePostAndGet<T> implements IBaseServiceGet<T> {
  Future<bool> postMethod();
}
