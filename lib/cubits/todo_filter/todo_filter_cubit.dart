import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';

part 'todo_filter_state.dart';

class TodoFilterCubit extends Cubit<TodoFilterState> {
  TodoFilterCubit() : super(TodoFilterState.initial());

  //*quando l'utente clicca sul tab cambia lo stato del filtro
  void changeFilter(Filter newFilter) {
    emit(state.copyWith(filter: newFilter));
  }
}
