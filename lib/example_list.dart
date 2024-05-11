import 'package:flutter/material.dart';
import 'package:flutter_example/example/animation/animation_example_1.dart';
import 'package:flutter_example/example/layouts/layout_example_1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'example/layouts/layout_example_2.dart';



/// Example Page should implement title, description [Text] in [Hero]
abstract class AbsExamplePage extends StatelessWidget {

  static final String HERO_KEY_TITLE = "title";
  static final String HERO_KEY_DESCRIPTION = "description";

  final String title;
  final String? description;
  const AbsExamplePage({super.key, required this.title, this.description});

  AppBar getAppBar(BuildContext context){
    return AppBar(
      title: Hero(
          tag: AbsExamplePage.HERO_KEY_TITLE,
          child: Material(
            child: Text(
              title,
              // define from [AppBar#titleTextStyle]
              style: AppBarTheme.of(context).titleTextStyle ??
                  Theme.of(context).textTheme.titleLarge,
            ),
          )
      ),
      bottom: description != null && description!.trim().isNotEmpty ? PreferredSize(
          preferredSize: Size.zero,
          child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              alignment: AlignmentDirectional.topStart,
              child: Hero(
                  tag: AbsExamplePage.HERO_KEY_DESCRIPTION,
                  child: Material(
                    child: Text(description!),
                  )
              )
          )
      ) : null,
    );
  }
}

/// Example Page should return this from [StatelessWidget.build] or [State.build]
class BaseExamplePage extends StatelessWidget {
  final AppBarHero appbar;
  final Widget? body, fab;
  const BaseExamplePage({super.key, required this.appbar, this.body, this.fab});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// An Example [title] is key should be unique in same list layer.
class Example {
  final String title, description;
  Example({required this.title, required this.description});
}

/// Example List Configuration
class ExampleConfig {
  final BuildContext context;
  ExampleConfig({required this.context});

  /// Define example list by TITLES.
  /// List is a "parent > child" structure.
  late List<(Example parent, List<Example> children)> list = [
    (
      Example(
        title: AppLocalizations.of(context)!.example_category_animation_title,
        description: AppLocalizations.of(context)!.example_category_animation_description
      ),
      [
        Example(
          title: AppLocalizations.of(context)!.animation_example_1_title,
          description: AppLocalizations.of(context)!.animation_example_1_description
        ),
      ]
    ),
    (
      Example(
        title: AppLocalizations.of(context)!.example_category_layout_title,
        description: AppLocalizations.of(context)!.example_category_layout_description
      ),
      [
        Example(
          title: AppLocalizations.of(context)!.layout_example_1_title,
          description: AppLocalizations.of(context)!.layout_example_1_description
        ),
      ]
    ),
  ];

  /// Define examples by parent TITLE + child TITLE.
  Widget? build(String parent, String child, String description) {
    var appbar = AppBarHero(titleTag: child);
    if (parent ==
        AppLocalizations.of(context)!.example_category_animation_title) {
      if (child == AppLocalizations.of(context)!.animation_example_1_title) {
        return AnimationExampleOne(appbar: appbar);
      }
    }
    if (parent == AppLocalizations.of(context)!.example_category_layout_title) {
      if (child == AppLocalizations.of(context)!.layout_example_1_title) {
        // return LayoutExampleOne(appbar: appbar);
        return LayoutExampleTwo(title: child, description: description);
      }
    }
    return null;
  }
}

// ignore: must_be_immutable
class ExampleList extends StatelessWidget {

  ExampleConfig? _config;

  ExampleList({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _config ??= ExampleConfig(context: context);

    return SliverList(
      // Use a delegate to build items as they're scrolled on screen.
      delegate: SliverChildBuilderDelegate(
        // The builder function returns a ListTile with a title that
        // displays the index of the current item.
        (context, index) => _getListItem(context, index),
        // Builds 1000 ListTiles
        childCount: _config!.list.length,
      ),
    );
  }

  Widget _getListItem(BuildContext context, int index) {
    (Example, List<Example>) expansion = _config!.list[index];
    Example parent = expansion.$1;
    List<Example> children = expansion.$2;
    List<Widget> widgets = [];
    for (var child in children) {
      Widget? widget = _config!.build(parent.title, child.title, child.description);
      if (widget == null) {
        continue;
      }
      widgets.add(
        _ListTileHero(
            titleTag: child.title,
            subTag: child.description.trim().isNotEmpty ? child.description : null,
            onTap: () {
              Navigator.of(context).push(_MyPageRoute<void>(builder: (context) {
                return widget;
              }));
            }),
      );
    }
    return ExpansionTile(
      title: Text(parent.title),
      subtitle: parent.description.trim().isNotEmpty ? Text(parent.description) : null,
      children: widgets,
    );
  }
}

/// Default page transition on example list item click to begin
class _MyPageRoute<T> extends MaterialPageRoute<T> {
  _MyPageRoute({
    required super.builder,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

/// Compose [_ListTileHero] [AppBarHero] to show hero transition
/// [titleTag] 以共同顯示的文字作為 [Hero] 標記防呆。
class _ListTileHero extends StatelessWidget {
  final String titleTag;
  final String? subTag;
  final GestureTapCallback? onTap;
  const _ListTileHero({
    required this.titleTag, required this.onTap, this.subTag
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
        tag: AbsExamplePage.HERO_KEY_TITLE,
        // Don't forget Material(), see example from:
        // https://docs.flutter.dev/ui/animations/hero-animations
        child: Material(
          child: Text(titleTag),
        ),
      ),
      subtitle: subTag != null && subTag!.trim().isNotEmpty ? Hero(
        tag: AbsExamplePage.HERO_KEY_DESCRIPTION,
        // Don't forget Material(), see example from:
        // https://docs.flutter.dev/ui/animations/hero-animations
        child: Material(
          child: Text(subTag!),
        ),
      ) : null,
      onTap: onTap,
    );
  }
}

class AppBarHero extends StatelessWidget implements PreferredSizeWidget {
  final String titleTag;
  AppBarHero({super.key, required this.titleTag});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Hero(
            tag: titleTag,
            child: Material(
              child: Text(
                titleTag,
                // define from [AppBar#titleTextStyle]
                style: AppBarTheme.of(context).titleTextStyle ??
                    Theme.of(context).textTheme.titleLarge,
              ),
            )));
  }

  /// measure appbar size #CHEAT
  final AppBar _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;
}

