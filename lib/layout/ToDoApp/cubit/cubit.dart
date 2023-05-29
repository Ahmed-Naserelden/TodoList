// ignore_for_file: unnecessary_import, prefer_const_constructors, unnecessary_brace_in_string_interps, avoid_print, import_of_legacy_library_into_null_safe, avoid_function_literals_in_foreach_calls

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/layout/ToDoApp/cubit/states.dart';

import '../../../modules/archived_tasks/archived_task_screen.dart';
import '../../../modules/done_task/done_task_screen.dart';
import '../../../modules/new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int cntFillField = 0;
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> tasks = [
    NewTasksScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];

  List<Map> newTasksData = [];
  List<Map> doneTasksData = [];
  List<Map> archiveTasksData = [];

  late Database database;
  bool isBottomSheetShown = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

//? ----------------------------DataBase---------------------------

  Future<String> getName() async {
    return 'Mohamed Is A Prophet Of Allah';
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print("database Created");
        String sql =
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)';
        database.execute(sql).then((value) {
          print('Table Created');
        }).catchError((err) {
          print(err.toString());
        });
      },
      onOpen: (database) {
        print("database Opened");
        getDate(database);
      },
    ).then((value) async {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  void insertDatabase(
      {String title = 'first Task',
        String date = '2/9/2022',
        String time = '12:12 AM',
        String status = 'pending'}) {
    String sql =
        'INSERT INTO tasks(title, date, time, status) VALUES (?, ?, ?, ?)';

    List val = [title, date, time, status];

    database.transaction((txn) async {
      await txn.rawInsert(sql, val);
    }).then((value) {
      print('${value} inserted Successfully');
      emit(AppInsertDataBaseState());

      getDate(database);
    }).catchError((err) {
      print('ERorr  - > - > - > \n $err');
    });
  }

  void getDate(database) {
    newTasksData = [];
    doneTasksData = [];
    archiveTasksData = [];

    emit(AppCreateDataBaseLoadingState());
    String sql = 'SELECT * FROM tasks';
    database.rawQuery(sql).then((value) {
      value.forEach((element) {
        if (element['status'] == 'pending') {
          newTasksData.add(element);
        } else if (element['status'] == 'done') {
          doneTasksData.add(element);
        } else if (element['status'] == 'archive') {
          archiveTasksData.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

//? -------------------------------------------------------

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNabBareState());
  }

  void update({required String status, required int id}) {
    String sql = 'UPDATE tasks SET status = ? WHERE id = ?';
    database.rawUpdate(sql, [status, id]).then((value) {
      getDate(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteData({required int id}) {
    String sql = 'DELETE FROM tasks WHERE id = ?';
    database.rawDelete(sql, [id]).then((value) {
      getDate(database);
      emit(AppDeleteDataBaseState());
    });
  }
}