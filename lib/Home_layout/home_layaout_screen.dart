import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/archivedTask/archivedscreen.dart';
import 'package:untitled/modules/doneTask/donescreen.dart';
import 'package:untitled/modules/newTask/task_screen.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';
import 'package:untitled/shared/listes.dart';
class layoutscreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseStates){

            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                key: scaffoldKey,
                appBar: AppBar(
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: [
                      Text(
                        'ToDo ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      Icon(
                        Icons.wb_sunny,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child:Center(
                          child: Text(
                            'y',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                body: state is! AppChangegetloadingStates ? AppCubit.get(context).screens[AppCubit.get(context).current]:Center(child: CircularProgressIndicator()),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.lightGreenAccent[700],
                  onPressed: () {
                    if (AppCubit.get(context).isBottomSheetShow) {
                      if (formKey.currentState.validate()) {
                        AppCubit.get(context).insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text,
                        );
                      }
                    } else {
                      scaffoldKey.currentState.showBottomSheet(
                            (context) => Container(
                              color: Colors.grey[400],
                              padding: EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: titleController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(color: Colors.black),
                                        labelText: 'Title Task',
                                        prefixIcon: Icon(
                                          Icons.title,
                                          color: Colors.green,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.4)),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.datetime,
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text = value.format(context).toString();
                                        });
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        labelText: 'Time Task',
                                        prefixIcon: Icon(
                                          Icons.watch_later,
                                          color: Colors.green,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.4)),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2021-12-01'),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      keyboardType: TextInputType.datetime,
                                      controller: dateController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        labelText: 'Date Task',
                                        prefixIcon: Icon(
                                          Icons.date_range_outlined,
                                          color: Colors.green,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.4)),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            elevation: 10,
                          ).closed.then((value) {
                        AppCubit.get(context).changeBottomSheet(
                          isShow: false,
                          icon:Icons.edit,
                        );
                      });
                      AppCubit.get(context).changeBottomSheet(
                        isShow: true,
                        icon:Icons.add,
                      );
                    }
                  },
                  child: Icon(
                    AppCubit.get(context). fpIcon,
                    color: Colors.white,
                  ),
                ),
                bottomNavigationBar: CurvedNavigationBar(
                  animationDuration: Duration(
                    milliseconds: 250,
                  ),
                  height: 45,
                  backgroundColor: Colors.white,
                  color: Colors.amberAccent,
                  index: AppCubit.get(context).current,
                  onTap: (index)
                  {
                    AppCubit.get(context).Changeindex(index);
                  },
                  items:
                  [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          'Tasks',
                          style:TextStyle(
                            color: Colors.white,
                            fontSize: 13
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.done,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          'Done',
                          style:TextStyle(
                              color: Colors.white,      fontSize: 13
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.archive,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          'archive',
                          style:TextStyle(
                              color: Colors.white,
                              fontSize: 13
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
