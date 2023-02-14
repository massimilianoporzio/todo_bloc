import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  //*add todo usando la stringa di descrizione
  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: newTodos));
    print('$state');
  }

  void editTodo(String id, String newDesc) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return todo.copyWith(desc: newDesc);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void toggleTodo(String id) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void removeTodo(String id) {
    final newTodos = state.todos.where((element) => element.id != id).toList();
    emit(state.copyWith(todos: newTodos));
  }
}
