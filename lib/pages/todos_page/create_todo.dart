import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/blocs.dart';

import '../../models/todo_model.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: const InputDecoration(labelText: 'What to do?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context
              .read<TodoListBloc>()
              .add(TodoListAddEvent(todoDesc: todoDesc));
          context.read<TodoFilterBloc>().add(const ChangeFilterEvent(
              newFilter: Filter.all)); //*ritorno a TUTTI
          newTodoController.clear(); //pulisco dopo aver fatto submit
        }
      },
    );
  }
}
