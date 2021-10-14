import 'objectbox.g.dart';
import 'db.dart';
import "package:path/path.dart" show join;
import 'dart:io' show Directory;

import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'dart:math';

Future<InternetAddress> ip() async {
  InternetAddress result;

  int code = Random().nextInt(255);
  var dgSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  dgSocket.readEventsEnabled = true;
  dgSocket.broadcastEnabled = true;
  final ret = dgSocket.timeout(Duration(milliseconds: 200), onTimeout: (sink) {
    sink.close();
  }).expand<InternetAddress>((event) {
    if (event == RawSocketEvent.read) {
      final dg = dgSocket.receive();
      if (dg != null && dg.data.length == 1 && dg.data[0] == code) {
        dgSocket.close();
        return [dg.address];
      }
    }
    return [];
  }).first;

  dgSocket.send([code], InternetAddress("255.255.255.255"), dgSocket.port);
  return ret;
}

Future<void> boot(String root) async {
  print(await ip());

  await Directory(root).create(recursive: true);

  final store = openStore(directory: join(root, "box"));

  final box = store.box<User>();
  final user = User(name: 'good');
  print(box.put(user));

  for (final i in box.getAll()) {
    print("${i.id} ${i.name}");
  }
  store.close();
}
