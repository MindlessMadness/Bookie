import 'package:bookie/screens/addABookScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/scr2.dart';
import './Screens/signupscr.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/info.dart';
import './screens/start_scr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(MyApp()),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Info>(
            create: (context) => Info("", ""),
            update: (context, value, previous) =>
                Info(value.token, value.userId))
      ],
      child: Consumer<Auth>(
        builder: (context, value, _) => MaterialApp(
          home: value.isAuth
              ? Consumer<Info>(
                  builder: (context, value1, _) => const Start())
              : FutureBuilder(
                  future: value.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Scaffold()
                          : SignUpScr()),
          theme: ThemeData(
            primaryColorLight: const Color.fromARGB(255, 12, 12, 12),
            scaffoldBackgroundColor: const Color.fromRGBO(240, 238, 228, 1),
            appBarTheme: AppBarTheme(
                color: const Color.fromARGB(255, 224, 201, 166),
                titleTextStyle: TextStyle(color: Colors.brown.shade900)),
          ),
          routes: {
            Start.route: (context) => const Start(),
            AddABook.route:(context) => const AddABook()
          },
        ),
      ),
    );
  }
}
