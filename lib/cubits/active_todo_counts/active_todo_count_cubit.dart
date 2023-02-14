import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';
import '../todo_list/todo_list_cubit.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  //*ascolto il cubit con la lista dei todos
  late final StreamSubscription todoListSubscription;
  //*numero iniziale di elementi
  final int initialActiveTodoCount;
  final TodoListCubit todoListCubit;

  ActiveTodoCountCubit(
      {required this.initialActiveTodoCount, required this.todoListCubit})
      : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoLisState) {
      print('todoListState: $todoLisState');
      //*sto ascoltando il cubit con la lista
      //*conto quelli che non sono completati
      final int currentActiveTodoCount = todoLisState.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;
      emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
    });
  }
  @override
  Future<void> close() {
    todoListSubscription.cancel(); //*non ascolto +
    return super.close();
  }
}
