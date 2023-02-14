import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';
import '../todo_filter/todo_filter_cubit.dart';
import '../todo_list/todo_list_cubit.dart';
import '../todo_search/todo_search_cubit.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  //*dipende da:
  //* - la lista dei todos
  //* - il filtro applicato
  //* - la parola di ricerca
  //* quindi dai tre cubit corrispondenti
  final TodoListCubit todoListCubit;
  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;

  //*e dovrà stare in ascolto di tutti e tre
  late final StreamSubscription todoFilterSubscription;
  late final StreamSubscription todoListSubscription;
  late final StreamSubscription todoSearchSubscription;

  //lista iniziale
  final List<Todo> initialTodoList;

  FilteredTodosCubit({
    required this.initialTodoList,
    required this.todoListCubit,
    required this.todoFilterCubit,
    required this.todoSearchCubit,
  }) : super(FilteredTodosState(filteredTodos: initialTodoList)) {
    todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      //*eseguito ogni volta che la lista cambia
      setFilteredTodos();
    });
    todoFilterSubscription =
        todoFilterCubit.stream.listen((TodoFilterState todoFilterState) {
      //*eseguito ogni volta che cambia il filtro
      setFilteredTodos();
    });
    todoSearchSubscription =
        todoSearchCubit.stream.listen((TodoSearchState todoSearchState) {
      //*eseguito ogni volta che la parola di ricerca cambia
      setFilteredTodos();
    });
  }

  //*metodi del cubit
  void setFilteredTodos() {
    List<Todo> _filteredTodos;
    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        _filteredTodos = todoListCubit.state.todos
            .where((element) => !element.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = todoListCubit.state.todos
            .where((element) => element.completed)
            .toList();
        break;
      case Filter.all:

      default:
        _filteredTodos = todoListCubit.state.todos;
        break;
      //FILTRATE PER COMPLETED
      //ORA FILTRO SE HO FATTO RICERCA
    }
    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((element) => element.desc
              .toLowerCase()
              .contains(todoSearchCubit.state.searchTerm))
          .toList();
    }
    //*emetto stato del cubit filtered con la lista filtrata
    emit(state.copyWith(filteredTodos: _filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
