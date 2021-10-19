import 'dart:async';

typedef Callback = FutureOr<void> Function();

class Exit {
  final List<Callback> li = [];
  void call(Callback callback) => li.add(callback);

  Future<void> operator -() async {
    for (var i in li) {
      await i();
    }
  }
}

final onExit = Exit();
