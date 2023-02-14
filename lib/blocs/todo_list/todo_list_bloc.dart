import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<TodoListAddEvent>(_addTodoHandler);
    on<TodoListEditEvent>(_editTodoHandler);
    on<TodoListToggleEvent>(_toggleTodoHandler);
    on<TodoListRemoveEvent>(_removeTodoHandler);
  }

  FutureOr<void> _addTodoHandler(
      TodoListAddEvent event, Emitter<TodoListState> emit) {
    //*ADD NEW TODO
    final newTodo = Todo(desc: event.todoDesc);
    final newTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: newTodos));
  }

  FutureOr<void> _editTodoHandler(
      TodoListEditEvent event, Emitter<TodoListState> emit) {
    //*EDIT TODO
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return todo.copyWith(desc: event.newDesc);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  FutureOr<void> _toggleTodoHandler(
      TodoListToggleEvent event, Emitter<TodoListState> emit) {
    //*TOGGLE TODO STATE
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  FutureOr<void> _removeTodoHandler(
      TodoListRemoveEvent event, Emitter<TodoListState> emit) {
    //*REMOVE TODO
    final newTodos =
        state.todos.where((element) => element.id != event.id).toList();
    emit(state.copyWith(todos: newTodos));
  }
}
