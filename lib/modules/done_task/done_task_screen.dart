import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/ToDoApp/cubit/cubit.dart';
import '../../layout/ToDoApp/cubit/states.dart';
import '../../shared/components/components.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasksData;
          return screenContent(tasks: tasks, message: "Done Tasks");
        });
  }
}