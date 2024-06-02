import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

///
/// [InteractionExampleOne] showcase
///
class InteractionExampleOne extends AbsExamplePage {

  static const String hero_tag_image = "image";

  const InteractionExampleOne({
    super.key, required super.title, super.description
  });


  @override
  Widget build(BuildContext context) {
    return BackEventBroadcast(
      child: LayoutBuilder(builder: (context, constraints){
        return Scaffold(
          appBar: getAppBar(context, constraints.maxWidth),
          body: getBody(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              const BackEvent().dispatch(context);
            }
          )
        );
      }),
    );
  }

  Widget? getBody() {
    return PageNavigator();
  }

}



class PageNavigator extends StatelessWidget {

  final GlobalKey<NavigatorState> _myNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _childNavigatorKey = GlobalKey();

  PageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // On FAB click to back
    return Consumer<BackEventProxy>(
      builder: (context, event, child) {
        if(_popChildNavigator()) {
          return child!;
        }
        if(_popMyNavigator()) {
          return child!;
        }
        // if the last back event is null,
        // current builder is on page initializing, don't pop
        if(event.last != null) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return child!;
      },
      child: LayoutBuilder(
        builder: (context, constraints){
          // check stack widget safe size
          var safe_size = min(constraints.maxWidth, constraints.maxHeight);
          return HeroControllerScope(
            controller: MaterialApp.createMaterialHeroController(),
            child: Navigator(
              key: _myNavigatorKey,
              initialRoute: "page/1",
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  // navigator default page
                  case "page/1":
                    return MaterialPageRoute<void>(
                      settings: settings,
                      builder: (BuildContext context) => GestureDetector(
                        onTap: (){
                          _popChildNavigator();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox.square(
                            dimension: safe_size,
                            child: ChildNavigator(navigatorKey: _childNavigatorKey),
                          )
                        ),
                      ),
                    );
                  // navigator final page
                  case "page/2":
                    return _PageRoute(
                        settings: settings,
                        builder: (BuildContext context) => LayoutBuilder(
                            builder: (context, constraints) {
                              // check stack widget safe size
                              var safe_size = min(constraints.maxWidth, constraints.maxHeight);
                              if(constraints.maxWidth >= constraints.maxHeight){
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: safe_size, height: safe_size,
                                        child: Hero(
                                            tag: InteractionExampleOne.hero_tag_image,
                                            child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg", fit: BoxFit.fill,)
                                        ),
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth - safe_size, height: safe_size,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            AppLocalizations.of(context)!.wiki_universe_description,
                                            overflow: TextOverflow.ellipsis,
                                            // overflow works with maxLines or will it be 1.
                                            maxLines: 1000,
                                          ),
                                        )
                                      ),
                                    ]
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: safe_size, height: safe_size,
                                      child: Hero(
                                          tag: InteractionExampleOne.hero_tag_image,
                                          child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg", fit: BoxFit.fill,)
                                      ),
                                    ),
                                    SizedBox(
                                      width: safe_size, height: constraints.maxHeight - safe_size,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          AppLocalizations.of(context)!.wiki_universe_description,
                                          overflow: TextOverflow.ellipsis,
                                          // overflow works with maxLines or will it be 1.
                                          maxLines: 1000,
                                        ),
                                      )
                                    ),
                                  ]
                                ),
                              );
                            }
                        )
                    );
                  default:
                    throw Exception('Unknown Route: ${settings.name}');
                }
              },
            ),
          );
        }
      ),
    );
  }

  bool _popChildNavigator() {
    if (_childNavigatorKey.currentState?.canPop() ?? false) {
      _childNavigatorKey.currentState!.pop();
      return true;
    }
    return false;
  }

  bool _popMyNavigator() {
    if (_myNavigatorKey.currentState?.canPop() ?? false) {
      _myNavigatorKey.currentState!.pop();
      return true;
    }
    return false;
  }

}


class ChildNavigator extends StatelessWidget {


  final GlobalKey<NavigatorState> navigatorKey;
  const ChildNavigator({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {

    // https://docs.flutter.dev/release/breaking-changes/hero-controller-scope
    return HeroControllerScope(
      controller: MaterialApp.createMaterialHeroController(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: 'child/1',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "child/1":
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed("child/2");
                    },
                    child: Card.filled(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        leading: Hero(
                          tag: InteractionExampleOne.hero_tag_image,
                          child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg", fit: BoxFit.fill,)
                        ),
                        trailing: Icon(Icons.ads_click),
                        title: Text(AppLocalizations.of(context)!.wiki_universe_title),
                      ),
                    ),
                  ),
                ),
              );
            case "child/2":
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => GestureDetector(
                  onTap: (){
                    navigatorKey.currentState?.popUntil((route) => route.isFirst);
                    navigatorKey.currentContext?.findAncestorStateOfType<NavigatorState>()?.pushNamed("page/2");
                  },
                  child: Card.filled(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(16),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Hero(
                          tag: InteractionExampleOne.hero_tag_image,
                          child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg", fit: BoxFit.fill,)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(AppLocalizations.of(context)!.wiki_universe_description, style: TextStyle(color: Colors.white))
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.bottomRight,
                          child: const Icon(Icons.ads_click, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              );
            default:
              throw Exception('Unknown Route: ${settings.name}');
          }
        },
      ),
    );
  }

}


class _PageRoute<T> extends MaterialPageRoute<T>  {
  /// Construct a MaterialPageRoute whose contents are defined by [builder].
  _PageRoute({
    required super.builder,
    super.settings,
    super.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  }) {
    assert(opaque);
  }

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

/// [BackEventBroadcast] works with [Consumer] type [BackEventProxy]
class BackEventBroadcast extends StatelessWidget {

  final Widget child;
  final BackEventProxy proxy = BackEventProxy();

  BackEventBroadcast({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BackEventProxy>(
      create:  (context) => proxy,
      child: NotificationListener<BackEvent>(
        onNotification: (notification) {
          proxy.send(notification);
          return true;
        },
        child: child,
      ),
    );
  }
}

class BackEvent extends Notification {
  const BackEvent();
}

class BackEventProxy extends ChangeNotifier {
  BackEvent? last;
  void send(BackEvent value) {
    last = value;
    notifyListeners();
  }
}
