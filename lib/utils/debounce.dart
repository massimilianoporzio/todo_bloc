//*per ridurre richieste a remote datsources
//l'evento di search verrà triggerato solo ogni 500ms man mano
// che l'utente digita se no ad ogni carattere digitato parte una ricerca
import 'dart:async';

import 'package:flutter/widgets.dart';

class Debounce {
  final int milliseconds;

  Debounce({this.milliseconds = 500});

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel(); //resetto e creo nuovo
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
