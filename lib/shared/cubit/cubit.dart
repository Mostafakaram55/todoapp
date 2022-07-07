import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/archivedTask/archivedscreen.dart';
import 'package:untitled/modules/doneTask/donescreen.dart';
import 'package:untitled/modules/newTask/task_screen.dart';
import 'package:untitled/shared/cubit/states.dart';

import '../listes.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit():super(AppInitialStates());

  static AppCubit get(context)=>BlocProvider.of(context);
  var current = 0;
  Database database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];
  bool isBottomSheetShow = false;
  IconData fpIcon = Icons.edit;
  List<Widget>screens =
  [
    taskscreen(),
    donescreen(),
    archivedscreen(),
  ];
  List<String> titles =
  [
    'Task',
    'Done Task',
    'Archived Task',
  ];
void Changeindex(int index)
{
  current=index;
  emit(AppChangeBottomNaveParStates());
}
  void createDatabase() //create data base *
      {
     openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {}).catchError((error) {
          print('error${error.toString()}');
        });
        print(
          'database Created',
        );
      },
      onOpen: (database)
      {
        GetFromDatabase(database);
      },
    ).then((value) {
      database=value;
      emit(AppGetDatabaseStates());
     });
  }
  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")').then((value) {
        print('$value inserted');
        emit(AppInsertDatabaseStates());
        GetFromDatabase(database);
      }).catchError((error)
      {
        print("error is ${error.toString()}");
      });
      return null;
    });
  }
  void GetFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
  emit(AppChangegetloadingStates());
  database.rawQuery('SELECT * FROM tasks').then((value)
   {
    value.forEach((element) {
      if(element ['status']=='new'){
        newTasks.add(element);
      }
      else if(element ['status']=='done'){
        doneTasks.add(element);
      }
      else if(element ['status']=='archived'){
        archivedTasks.add(element);
      }
    });
    emit(AppCreateDatabaseStates());
   });
  }
  void changeBottomSheet({
  @required bool isShow,
  @required IconData icon,
}){
    isBottomSheetShow=isShow;
    fpIcon=icon ;
    emit(AppChangeBottomSheetStates());
  }
void UpdateDate({
  @required String status,
  @required int id,
})async
{
  database.rawUpdate(
      'UPDATE tasks SET status=? WHERE id= ?',
       ['$status',id]
      ).then((value)
  {
     GetFromDatabase(database);
        emit(AppUpdateStates());
  });

}
  void DeletDate({
    @required int id,
  })async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id=?',
        [id]
    ).then((value)
    {
      GetFromDatabase(database);
      emit(Appdelettates());
    });

  }
}