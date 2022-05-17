import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  int _selectedMenudOpt = 0;

  // ignore: unnecessary_getters_setters
  int get selectedMenudOpt {
    return _selectedMenudOpt;
  }

  set selectedMenudOpt(int i) {
    _selectedMenudOpt = i;
    /**
     * i Al extender de ChangeNotifier tenemos acceso a este método que se 
     * i encarga de notificar a todo el que esté escuchando al provider
     */
    notifyListeners();
  }
}
