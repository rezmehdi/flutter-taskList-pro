import 'package:task_list/data/source/source.dart';

class Repository<T> implements DataSource {
  final DataSource<T> localDataSource;
  // final DataSource<T> remoteDataSource;

  Repository(this.localDataSource);
  @override
  Future createOrUpdate(data) {
    return localDataSource.createOrUpdate(data);
  }

  @override
  Future<void> delete(data) {
    return localDataSource.delete(data);
  }

  @override
  Future<void> deleteAll() {
    return deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return deleteById(id);
  }

  @override
  Future findById(id) {
    return findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return getAll(searchKeyword: searchKeyword);
  }
}
