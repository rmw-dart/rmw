import 'objectbox.g.dart';

void run(String directory){
  final store = openStore(directory:directory);
  store.close();
  print('Hello world!');
}
