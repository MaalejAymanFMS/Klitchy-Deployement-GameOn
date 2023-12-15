import 'package:flutter/material.dart';
import 'package:klitchyapp/routes/routes.dart';
import 'package:klitchyapp/utils/locator.dart';
import 'package:klitchyapp/views/kitchen.dart';
import 'package:klitchyapp/views/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:klitchyapp/utils/AppState.dart' as UtilAppState;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UtilAppState.AppState(),
      child: MaterialApp(
        title: 'Klitchy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(Colors.white),
              thumbVisibility: MaterialStateProperty.all(true),
              trackColor:MaterialStateProperty.all(Colors.white38),
              trackVisibility: MaterialStateProperty.all(true),
            ),
        ),
        home: SplashScreen(),

        routes: PageRoutes().routes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
