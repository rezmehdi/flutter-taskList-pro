import 'package:flutter/material.dart';
import 'package:task_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource {
  final DataSource<T> localDataSource;
  // final DataSource<T> remoteDataSource;

  Repository(this.localDataSource);
  @override
  Future createOrUpdate(data) async {
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(data) async {
    localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
