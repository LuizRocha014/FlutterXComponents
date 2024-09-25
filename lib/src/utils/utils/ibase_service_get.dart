abstract class IBaseServiceGet<T> {
  Future<List<T>> getAll({bool alteracaoNula = false});
}
