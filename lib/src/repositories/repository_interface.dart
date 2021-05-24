class RepositoryInterface<T> {
  Future<T> upsert(T variable) {
    throw Exception("Not Implemented");
  }

  Future<T> fetch(int id) {
    throw Exception("Not Implemented");
  }
}