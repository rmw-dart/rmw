import 'dart:async';
import 'dart:io';
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

  Exit() {
    final exitSignal = [ProcessSignal.sigint];
    if (!Platform.isWindows) {
      exitSignal.add(ProcessSignal.sigterm);
    }

    for (var hook in exitSignal) {
      hook.watch().listen((signal) async {
        await -this;
        exit(0);
      });
    }
  }
}

final onExit = Exit();
