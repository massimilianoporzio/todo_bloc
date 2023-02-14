import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(todos[index].id),
        background: showBackground(0), //swipe  a dx
        secondaryBackground: showBackground(1), //swipe a sin
        onDismissed: (direction) {
          context
              .read<TodoListBloc>()
              .add(TodoListRemoveEvent(id: todos[index].id));
        },
        confirmDismiss: (direction) {
          return showDialog(
            barrierDismissible: false, //NON si chiude se clicco fuori
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text("Do you really want to delete this item?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false); //false: NO
                    },
                    child: const Text('NO'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true); //false: NO
                    },
                    child: const Text('YES'),
                  ),
                ],
              );
            },
          );
        },
        child: TodoItem(
          todo: todos[index],
        ),
      ),
    );
  }

//*mostra il background quando swipe per cancellare il todo
  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool error = false;
            _textController.text = widget.todo.desc;
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Edit Todo'),
                  content: TextField(
                    controller: _textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: error ? "Value cannot be empty" : null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCEL"),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(
                            () {
                              error =
                                  _textController.text.isEmpty ? true : false;
                              if (!error) {
                                //avverto che lo stato è cambiato
                                context.read<TodoListBloc>().add(
                                    TodoListEditEvent(
                                        id: widget.todo.id,
                                        newDesc: _textController.text));
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: const Text("EDIT"))
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          //CAMBIA LO STATO DI QUEL TODO
          context.read<TodoListBloc>().add(TodoListToggleEvent(id: widget.todo.id));
        },
      ),
      title: Text(
        widget.todo.desc,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
