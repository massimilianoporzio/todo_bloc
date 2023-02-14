import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';
import '../blocs.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  //*dipende da:
  //* - la lista dei todos
  //* - il filtro applicato
  //* - la parola di ricerca
  //* quindi dai tre cubit corrispondenti
  final TodoListBloc todoListBloc;
  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;

  //*e dovrà stare in ascolto di tutti e tre
  late final StreamSubscription todoFilterSubscription;
  late final StreamSubscription todoListSubscription;
  late final StreamSubscription todoSearchSubscription;

  //lista iniziale
  final List<Todo> initialTodoList;

  FilteredTodosBloc({
    required this.todoListBloc,
    required this.todoFilterBloc,
    required this.todoSearchBloc,
    required this.initialTodoList,
  }) : super(FilteredTodosState(filteredTodos: initialTodoList)) {
    //mi mettto in ascolto
    //*quando la lista di todo cambia emetto l'evento di filtrare
    todoListSubscription = todoListBloc.stream.listen(
      (TodoListState state) {
        setFilteredTodos();
      },
    );
    //*quando il filtro cambia emetto l'evento di filtrare
    todoFilterSubscription = todoFilterBloc.stream.listen(
      (TodoFilterState state) => setFilteredTodos(),
    );
    //*quando cambio il testo da ricercare emetto l'evento di filtrare
    todoSearchSubscription = todoSearchBloc.stream.listen(
      (TodoSearchState state) => setFilteredTodos(),
    );

    //*ESEGUO IL FILTRAGGIO DEI TODOS
    on<SetFilteredTodosEvent>((event, emit) {
      //*emetto stato del cubit filtered con la lista filtrata
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos; //risultato da resitituire

    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos = todoListBloc.state.todos
            .where((element) => !element.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListBloc.state.todos
            .where((element) => element.completed)
            .toList();
        break;
      case Filter.all:

      default:
        filteredTodos = todoListBloc.state.todos;
        break;
      //FILTRATE PER COMPLETED
    }
    //ORA FILTRO SE HO FATTO RICERCA
    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((element) => element.desc
              .toLowerCase()
              .contains(todoSearchBloc.state.searchTerm))
          .toList();
    }
    add(SetFilteredTodosEvent(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
