part of 'filtered_todos_bloc.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class SetFilteredTodosEvent extends FilteredTodosEvent {
  final List<Todo> filteredTodos;

  const SetFilteredTodosEvent({
    required this.filteredTodos,
  });

  @override
  String toString() => 'SetFilteredTodosEvent(filteredTodos: $filteredTodos)';

  @override
  List<Object> get props => [filteredTodos];
}
