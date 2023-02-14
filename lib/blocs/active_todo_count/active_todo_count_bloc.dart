import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/blocs.dart';

import '../../models/todo_model.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  //*ascolto il cubit con la lista dei todos
  late final StreamSubscription todoListSubscription;
  //*numero iniziale di elementi
  final int initialActiveTodoCount;
  //*BLOC DI CUI STO IN ASCOLTO
  final TodoListBloc todoListBloc;

  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
    required this.todoListBloc,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    //*quando costruisco un ActiveCountBloc
    todoListSubscription =
        todoListBloc.stream.listen((TodoListState todoLisState) {
      print('todoListState: $todoLisState');
      //*sto ascoltando il bloc con la lista
      //*conto quelli che non sono completati
      final int currentActiveTodoCount = todoLisState.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;
      add(CalculateActiveTodoCountEvent(
          activeTodoCount: currentActiveTodoCount));
    });

    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel(); //non ascolto più
    return super.close();
  }
}
//*Nuova istanza del BLOC: gli passo il numero di attivi iniziale
//*lo metto in ascolto del bloc TodoList con la lista
//*così quando la lista di todo cambia posso reagire:
//* -corregg il numero iniziale di elementi passato al costruttore con il
//*   conteggio esatto dei todo che NON sono completed
//* - aggiungendo un evento allo stream del blocco stesso che chiede l'aggiornamento
//*   dello stato
//*quando arriva l'evento col numero calcolato emetto il nuovo stato con il
//*numero aggiornato

