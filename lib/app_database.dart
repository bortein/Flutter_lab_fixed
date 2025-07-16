import 'dart:async';
import 'package:floor/floor.dart';
import 'shopping_item.dart';
import 'shopping_item_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ShoppingItem])
abstract class AppDatabase extends FloorDatabase {
  ShoppingItemDao get itemDao;
}
