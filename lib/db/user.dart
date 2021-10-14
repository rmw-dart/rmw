import 'package:objectbox/objectbox.dart';
import 'dart:typed_data';

@Entity()
class User {
  int id = 0;

  late String name;

  @Index()
  late String ip;

  User({required this.name});
}

