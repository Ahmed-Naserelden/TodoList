// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_final_fields, must_be_immutable, unused_field, unused_local_variable, import_of_legacy_library_into_null_safe, unnecessary_brace_in_string_interps

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppCubit cubit = cubit;
    // return BlocProvider(
    //   create: (BuildContext context) => AppCubit()..createDatabase(), //

    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          if (state is AppInsertDataBaseState) {
            cubit.titleController.text = '';
            cubit.dateController.text = '';
            cubit.timeController.text = '';
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Center(
                child: Text(cubit.titles[cubit.currentIndex]),
              ),
            ),
            body: ConditionalBuilder(
              condition: state
              is! AppCreateDataBaseLoadingState, //true, //tasksData.isNotEmpty,
              builder: (context) => cubit.tasks[cubit.currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: cubit.titleController.text,
                        time: cubit.timeController.text,
                        date: cubit.dateController.text);
                  }
                } else {
                  cubit.scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                              controller: cubit.titleController,
                              text: "Title",
                              textInputType: TextInputType.text,
                              prefixicon: Icon(Icons.title),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                                controller: cubit.timeController,
                                text: "Time",
                                textInputType: TextInputType.datetime,
                                prefixicon: Icon(Icons.watch_later_outlined),
                                ontap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    cubit.timeController.text =
                                        value!.format(context);
                                    print('\n${value.format(context)}\n');
                                  });
                                }),
                            SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                                controller: cubit.dateController,
                                text: "Date",
                                textInputType: TextInputType.datetime,
                                prefixicon: Icon(Icons.calendar_month_outlined),
                                ontap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate:
                                      DateTime.parse('2022-12-25'))
                                      .then((value) {
                                    cubit.dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                }),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 15.0,
                  )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });

                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outlined),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ]),
          );
        }),
    );

  }
}




/*
 * onPressed: () /*async*/ {
      //? try {
      //?   var name = await getName();
      //?   print('Name : $name');
      //?   print("Osama");
      //?   // throw ('Some Error !!!!!!!!!! !!!!!! !!!!'); //! ahmed make error by hand.
      //? } catch (err) {
      //?   print('Error : ${err.toString()}');
      //? }
      //? insertDatabase();
      //? getName().then((value) {
      //?   print(value);
      //?  print('Osama');
      //? }).catchError((err) {
      //?   print(err.toString());
      //? });
  //? }
 */