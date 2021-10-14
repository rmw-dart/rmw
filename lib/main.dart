import 'objectbox.g.dart';

void Main(String directory){
  final store = openStore(directory:directory);
  store.close();
  print('Hello world!');
}
