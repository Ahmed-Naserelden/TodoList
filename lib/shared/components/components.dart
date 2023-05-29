// ignore_for_file: prefer_const_constructors, avoid_init_to_null, prefer_if_null_operators, non_constant_identifier_names, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables
import 'package:bloc/bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import '../../layout/ToDoApp/cubit/cubit.dart';

void navigatTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = const Color.fromARGB(255, 64, 101, 131),
  double radius = 0.0,
  required String name,
  required Function function,
}) =>
    Container(
      width: width,
      // color: backgroundColor,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required String text,
  required TextInputType textInputType,
  required var prefixicon,
  var suffixicon = null,
  var isSuffixicon = false,
  bool isPassword = false,
  Function? suffixPressed,
  Function? validate,
  Function? ontap,
  var onchange,
  var contexti = null,
}) =>
    TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          // hintText: "Email Adress",

          labelText: text,
          border: OutlineInputBorder(),
          prefixIcon: prefixicon,
          suffixIcon: suffixicon == null
              ? null
              : IconButton(
            icon: Icon(suffixicon),
            onPressed: () {
              suffixPressed!();
            },
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field Is Emapty';
          } else {
            if (text == 'Email Adress') {
              bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return '$value not valid email';
              }
            }
          }
          return null;
        },
        onChanged: onchange,
        onTap: ontap == null
            ? null
            : () {
          ontap();
        });

Widget bulidTaskItem({
  required Map model,
  required context,
  var color = Colors.blue,
}) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.0,
        top: 10.0,
        bottom: 10.0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(
              model['time'],
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            radius: 40.0,
            backgroundColor: color,
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  model['title'],
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  model['date'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).update(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).update(
                status: 'archive',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (directioin) {
      AppCubit.get(context).deleteData(
        id: model['id'],
      );
    },
  );
}

Widget screenContent({
  required List<Map> tasks,
  String message = "Add Task",
}) {
  return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 102,
              color: Colors.grey,
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return bulidTaskItem(
                model: tasks[index],
                context: context,
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                height: 1.0,
              );
            },
            itemCount: tasks.length);
      });
}

Widget NewsScreenContent(condition, article, context) {
  return ConditionalBuilder(
      condition: condition, // state is! NewsGetBusinessLoadingState,
      fallback: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      builder: (context) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return articleBuilder(article: article[index], context: context);
          },
          separatorBuilder: (context, index) {
            return Container(
              color: Colors.grey[300],
              height: 1.0,
            );
          },
          itemCount: article.length,
        );
      });
}

Widget articleBuilder({required article, required context}) {
  return Padding(
    padding: EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: getImage('${article['urlToImage']}'),
              //image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfHY0NWX2r98I83wWHdL6S7qdqVGWvsXLt7v5iYczx&s'),
                image: NetworkImage(article['urlToImage'] != null &&
                    article['urlToImage'] !=
                        "https://www.aljazeera.net/wp-content/uploads/2022/09/موساصور-1-.jpg?resize=1920%2C1280"
                    ? '${article['urlToImage']}'
                    : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfHY0NWX2r98I83wWHdL6S7qdqVGWvsXLt7v5iYczx&s'),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                      '${article['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

NetworkImage getImage(urlToImage) {
  var image;
  urlToImage ??=
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfHY0NWX2r98I83wWHdL6S7qdqVGWvsXLt7v5iYczx&s';

  try {
    image = NetworkImage(urlToImage);
  } catch (err) {
    print(err.toString());
    image = NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfHY0NWX2r98I83wWHdL6S7qdqVGWvsXLt7v5iYczx&s");
  }
  return image;
}
