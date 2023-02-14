import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/pages/todos_page/todos_page.dart';

import 'blocs/blocs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterBloc>(
          create: (context) => TodoFilterBloc(),
        ),
        BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        //passo al costruttore quelli già creati
        BlocProvider<ActiveTodoCountBloc>(
          create: (context) => ActiveTodoCountBloc(
              initialActiveTodoCount:
                  context.read<TodoListBloc>().state.todos.length,
              todoListBloc: BlocProvider.of<TodoListBloc>(context)),
        ),
        BlocProvider<FilteredTodosBloc>(
          create: (context) => FilteredTodosBloc(
              initialTodoList: context.read<TodoListBloc>().state.todos,
              todoListBloc: context.read<TodoListBloc>(),
              todoFilterBloc: context.read<TodoFilterBloc>(),
              todoSearchBloc: context.read<TodoSearchBloc>()),
        ),
      ],
      child: MaterialApp(
          title: 'Todo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TodosPage()),
    );
  }
}
