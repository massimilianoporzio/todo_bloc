part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class TodoListAddEvent extends TodoListEvent {
  final String todoDesc;

  const TodoListAddEvent({
    required this.todoDesc,
  });

  @override
  String toString() => 'TodoListAddEvent(todoDesc: $todoDesc)';

  @override
  List<Object> get props => [todoDesc];
}

class TodoListEditEvent extends TodoListEvent {
  final String id;
  final String newDesc;

  const TodoListEditEvent({
    required this.id,
    required this.newDesc,
  });

  @override
  List<Object> get props => [id, newDesc];

  @override
  String toString() => 'TodoListEditEvent(id: $id, newDesc: $newDesc)';
}

class TodoListToggleEvent extends TodoListEvent {
  final String id;

  const TodoListToggleEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'TodoListToggleEvent(id: $id)';
}

class TodoListRemoveEvent extends TodoListEvent {
  final String id;
  const TodoListRemoveEvent({
    required this.id,
  });

  @override
  String toString() => 'TodoListRemoveEvent(id: $id)';

  @override
  List<Object> get props => [id];
}
