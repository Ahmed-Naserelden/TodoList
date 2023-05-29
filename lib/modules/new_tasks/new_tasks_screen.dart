import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/ToDoApp/cubit/cubit.dart';
import '../../layout/ToDoApp/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);
  // final List<Map>? tasks;
  // const NewTasksScreen({Key? key,
  //   this.tasks,
  // }) : super(key: key);
  // const NewTasksScreen({this.tasks = null});

  //! wellcome ahmed.
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasksData;
          return screenContent(tasks: tasks);
        });
  }
}