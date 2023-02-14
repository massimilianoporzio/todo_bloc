import 'package:flutter/material.dart';
import 'package:todo_bloc/pages/todos_page/search_filter_todos.dart';
import 'package:todo_bloc/pages/todos_page/show_todos.dart';
import 'package:todo_bloc/pages/todos_page/todos_header.dart';

import 'create_todo.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const TodoHeader(),
                const CreateTodo(),
                const SizedBox(
                  height: 20,
                ),
                SearchAndFilterTodo(),
                const ShowTodos()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
