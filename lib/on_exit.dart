import 'dart:async';
import 'package:try_catch/init.dart';

typedef Callback = FutureOr<void> Function();

class Exit {
  final List<Callback> li = [];
  void call(Callback callback) => li.add(callback);

  Future<void> operator -() async {
    for (var i in li) {
      await tryCatch(i);
    }
  }
}

final onExit = Exit();
