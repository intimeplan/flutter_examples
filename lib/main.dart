import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/example_list.dart';
import 'package:flutter_example/information_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'example/interaction/interaction_example_1.dart';

void main() {
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context){
        return AppLocalizations.of(context)!.appName;
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          // OR https://flutter.dev/brand
          seedColor: Colors.cyan,
          brightness: MediaQuery.of(context).platformBrightness
        ),
        // brightness: Brightness.dark,
        useMaterial3: true,
        // primaryColor: Colors.cyan,
        // primaryColorDark: Colors.cyan
      ),
      home: const MyHomePage(
        title: 'Flutter Examples'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      body: _MyPages(navigatorKey: _navigatorKey),
      // navigation drawer
      // https://docs.flutter.dev/cookbook/design/drawer
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // TRY THIS: Try changing the color here to a specific color (to
                // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
                // change color while the other colors stay the same.
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text(AppLocalizations.of(context)!.appName),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.example_page_title),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                _navigatorKey.currentState?.pushReplacementNamed("examples");
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.information_page_title),
              onTap: () {
                // Navigator.pop(context);
                _scaffoldKey.currentState?.closeDrawer();
                _navigatorKey.currentState?.pushReplacementNamed("information");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPages extends StatelessWidget{

  final GlobalKey<NavigatorState> navigatorKey;
  const _MyPages({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: MaterialApp.createMaterialHeroController(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: "examples",
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            // navigator default page
            case "examples":
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => CustomScrollView(
                  // Add the app bar and list of items as slivers in the next steps.
                  slivers: <Widget>[
                    // Add the app bar to the CustomScrollView.
                    SliverAppBar(
                      // Provide a standard title.
                      title: Text(AppLocalizations.of(context) != null ? AppLocalizations.of(context)!.example_page_title : ""),
                      // Allows the user to reveal the app bar if they begin scrolling
                      // back up the list of items.
                      floating: true,
                      // // Display a placeholder widget to visualize the shrinking size.
                      // flexibleSpace: Placeholder(),
                      // // Make the initial height of the SliverAppBar larger than normal.
                      // expandedHeight: 200,
                    ),
                    // Next, create a SliverList
                    ExampleList()
                  ]
                ),
              );
            // navigator final page
            case "information":
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => InformationPage(),
              );
            default:
              throw Exception('Unknown Route: ${settings.name}');
          }
        },
      ),
    );
  }
}

