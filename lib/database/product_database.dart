import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._internal();
  static Database? _database;

  ProductDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'products.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
      CREATE TABLE ${ProductFields.tableName} (
        ${ProductFields.id} ${ProductFields.idType},
        ${ProductFields.name} ${ProductFields.textType},
        ${ProductFields.price} ${ProductFields.realType},
        ${ProductFields.isAvailable} ${ProductFields.intType},
        ${ProductFields.createdDate} ${ProductFields.textType},
        ${ProductFields.eventDate} ${ProductFields.textType},
        ${ProductFields.description} ${ProductFields.textType}
      )
    ''');
  }

  Future<Product> create(Product product) async {
    final db = await instance.database;
    final id = await db.insert(ProductFields.tableName, product.toJson());
    return product.copy(id: id);
  }

  Future<Product> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      ProductFields.tableName,
      columns: ProductFields.values,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Product>> readAll() async {
    final db = await instance.database;
    const orderBy = '${ProductFields.createdDate} DESC';
    final result = await db.query(ProductFields.tableName, orderBy: orderBy);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<int> update(Product product) async {
    final db = await instance.database;
    return db.update(
      ProductFields.tableName,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      ProductFields.tableName,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}