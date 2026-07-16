import 'failures.dart';

class Result<T> {
  final T? _data;
  final Failure? _failure;

  const Result._({T? data, Failure? failure})
      : _data = data,
        _failure = failure;

  factory Result.success(T data) => Result._(data: data);

  factory Result.failure(Failure failure) => Result._(failure: failure);

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  T get data {
    if (_data == null) {
      throw StateError('Cannot access data on a failure Result');
    }
    return _data;
  }

  Failure get failure {
    if (_failure == null) {
      throw StateError('Cannot access failure on a success Result');
    }
    return _failure;
  }

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (_data != null) {
      return onSuccess(_data as T);
    }
    return onFailure(_failure!);
  }
}
