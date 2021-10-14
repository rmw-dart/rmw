import 'objectbox.g.dart';

import "package:path/path.dart" show join;

void boot(String directory){
  final store = openStore(directory:join(directory,"box"));
  store.close();
  print('Hello world!');
}
