import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';

typedef CallableHandler = Future<dynamic> Function(dynamic parameters);

class StubFirebaseFunctions extends Fake implements FirebaseFunctions {
  StubFirebaseFunctions({Map<String, CallableHandler>? handlers})
    : _handlers = handlers ?? <String, CallableHandler>{};

  final Map<String, CallableHandler> _handlers;

  void registerHandler(String name, CallableHandler handler) {
    _handlers[name] = handler;
  }

  @override
  HttpsCallable httpsCallable(
    String functionName, {
    HttpsCallableOptions? options,
  }) {
    final handler = _handlers[functionName];
    if (handler == null) {
      throw ArgumentError('No handler registered for $functionName');
    }
    return _StubHttpsCallable(handler);
  }
}

class _StubHttpsCallable extends Fake implements HttpsCallable {
  _StubHttpsCallable(this._handler);

  final CallableHandler _handler;

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    final result = await _handler(parameters);
    return _StubHttpsCallableResult<T>(result as T);
  }
}

class _StubHttpsCallableResult<T> extends Fake
    implements HttpsCallableResult<T> {
  _StubHttpsCallableResult(this._data);

  final T _data;

  @override
  T get data => _data;
}
