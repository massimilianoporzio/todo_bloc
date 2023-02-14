import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/blocs.dart';
import '../../models/todo_model.dart';

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});
  //*debounce per ridurre numero di ricerche //PER IL BLOC LO FACCIO CON GLI
  //*EVENT TRANSFORMERS

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
              labelText: 'Search todos...',
              border: InputBorder.none,
              filled: true,
              prefixIcon: Icon(Icons.search)),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              //*ogni volta che scrivo triggero l'evento
              //*ma dentro una debounce che fa partire un timer, e DOPO
              //*triggera l'evento di ricerca

              context
                  .read<TodoSearchBloc>()
                  .add(SetSearchTermEvent(newSearchTerm: newSearchTerm));
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        )
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
        onPressed: () {
          context
              .read<TodoFilterBloc>()
              .add(ChangeFilterEvent(newFilter: filter));
        },
        child: Text(
          toBeginningOfSentenceCase(filter.name)!,
          style: TextStyle(fontSize: 18, color: textColor(context, filter)),
        ));
  }

  Color textColor(BuildContext context, Filter filter) {
    Filter currentFilterState = context.watch<TodoFilterBloc>().state.filter;
    return filter == currentFilterState ? Colors.blue : Colors.grey;
  }
}
