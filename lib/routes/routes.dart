import 'package:flutter/material.dart';
import '../views/gestion_de_table.dart';

class PageRoutes {
  static const String startPage = 'start_page';
  static const String gestionDeTable = 'gestion_de_table';

  Map<String, WidgetBuilder> routes() {
    return {
      // startPage: (context) => const StartPageUI(),
      gestionDeTable: (context) => const GestionDeTable(),
    };
  }
}
