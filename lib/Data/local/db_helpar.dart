
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  Database? Db;

  DatabaseHelper._();

  static final _instance = DatabaseHelper._();

  static DatabaseHelper getinstanec(){
    return _instance;
  }

  Future<Database> opendb() async {
    if(Db!=null){
      print("Database Already Exists : ${Db}");
      return Db!;
    }else{
      print("Create Database");
      return await createdb();
    }
  }

  Future<Database> createdb() async {
    try{
      if(Db==null){
        String dir = await getDatabasesPath();
        String dbpath = join(dir,"SqliteDb.db");
        Db = await openDatabase(dbpath,onCreate: (Database db,int version){
          db.execute('''
            CREATE TABLE Notes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              detail TEXT NOT NULL
            )
      ''');
        },version: 1);
      }
    }catch(e){
      print("---------------- Create Error : ${e} ------------------");
    }
    print("Database : ${Db}");
    return Db!;
  }

  Future<bool> insertdata({required String title,required String detail}) async {
    try{
      if(Db==null){
        Db = await opendb();
      }
      int insertd = await Db!.insert("Notes", {
        "title" : title,
        "detail" : detail
      });
      return insertd>0;
    }catch(e){
      print("---------- Insert Error : ${e} -----------------");
    }
    return false;
  }

  Future<List<Map<String ,dynamic>>> SelectData() async {
    if(Db==null){
      Db = await opendb();
    }
    List<Map<String ,dynamic>> GetData = await Db!.query("Notes");
    print("SetData : ${GetData}");
    return await GetData;
  }

  Future<bool> UpdateData( {required String title, required String description, required int update_id} ) async {
    if(Db==null){
      Db = await opendb();
    }
    int update = await  Db!.update("Notes", {
      "title" : title,
      "detail" : description
    }, where: "id = ${update_id}");
    return update>0;
  }

  Future<bool> DeleteData ({required int delete_id}) async {
    if(Db==null){
      Db = await opendb();
    }
    int deleted_row = await Db!.delete("Notes",where: "id = ${delete_id}");
    return deleted_row>0;
  }

}
