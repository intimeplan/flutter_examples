import 'package:flutter/material.dart';
import 'package:flutter_example/example/animation/animation_example_1.dart';
import 'package:flutter_example/example/animation/animation_example_2.dart';
import 'package:flutter_example/example/interaction/interaction_example_1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'example/layouts/layout_example_1.dart';
import 'example/layouts/layout_example_2.dart';
import 'example/templates/template_example_1.dart';



/// Example Page should implement title, description [Text] in [Hero]
abstract class AbsExamplePage extends StatelessWidget {

  // Bug?? hero with same key won't animate again when open another page.
  // static const String hero_key_title = "title";
  // static const String hero_key_description = "description";
  static const int description_max_lines = 3;

  final String title;
  final String? description;
  const AbsExamplePage({super.key, required this.title, this.description});

  /// [maxWidth] to measure text height to set [AppBar.bottom] preferred size
  AppBar getAppBar(BuildContext context, double maxWidth){
    return AppBar(
      title: Hero(
          tag: title, // AbsExamplePage.hero_key_title,
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
          preferredSize: Size.fromHeight(
            _textSize(
              description!,
              Theme.of(context).textTheme.bodyMedium!,
              description_max_lines,
              maxWidth - 32           // maxWidth - (EdgeInsets left + right)
            ).height + 32             // height + (EdgeInsets top + bottom)
          ),
          child: Container(
              padding: const EdgeInsets.all(16),
              alignment: AlignmentDirectional.topStart,
              child: Hero(
                  tag: description!,  // AbsExamplePage.hero_key_description,
                  child: Material(
                    child: Text(description!, maxLines: description_max_lines, overflow: TextOverflow.ellipsis,),
                  )
              )
          )
      ) : null,
    );
  }

  Size _textSize(String text, TextStyle style, int maxLines, double maxWidth) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
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
        Example(
            title: AppLocalizations.of(context)!.animation_example_2_title,
            description: AppLocalizations.of(context)!.animation_example_2_description
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
        Example(
            title: AppLocalizations.of(context)!.layout_example_2_title,
            description: AppLocalizations.of(context)!.layout_example_2_description
        ),
      ]
    ),
    (
    Example(
        title: AppLocalizations.of(context)!.example_category_interaction_title,
        description: AppLocalizations.of(context)!.example_category_interaction_description
    ),
    [
      Example(
          title: AppLocalizations.of(context)!.interaction_example_1_title,
          description: AppLocalizations.of(context)!.interaction_example_1_description
      ),
    ]
    ),
    (
    Example(
        title: AppLocalizations.of(context)!.example_category_template_title,
        description: AppLocalizations.of(context)!.example_category_template_description
    ),
    [
      Example(
          title: AppLocalizations.of(context)!.template_example_1_title,
          description: AppLocalizations.of(context)!.template_example_1_description
      ),
    ]
    ),
  ];

  /// Define examples by parent TITLE + child TITLE.
  Widget? build(String parent, String child, String description) {
    if (parent == AppLocalizations.of(context)!.example_category_animation_title) {
      if (child == AppLocalizations.of(context)!.animation_example_1_title) {
        return AnimationExampleOne(title: child, description: description);
      }
      if (child == AppLocalizations.of(context)!.animation_example_2_title) {
        return AnimationExampleTwo(title: child, description: description);
      }
    }
    if (parent == AppLocalizations.of(context)!.example_category_layout_title) {
      if (child == AppLocalizations.of(context)!.layout_example_1_title) {
        return LayoutExampleOne(title: child, description: description);
      }
      if (child == AppLocalizations.of(context)!.layout_example_2_title) {
        return LayoutExampleTwo(title: child, description: description);
      }
    }
    if (parent == AppLocalizations.of(context)!.example_category_interaction_title) {
      if (child == AppLocalizations.of(context)!.interaction_example_1_title) {
        return InteractionExampleOne(title: child, description: description);
      }
    }
    if (parent == AppLocalizations.of(context)!.example_category_template_title) {
      if (child == AppLocalizations.of(context)!.template_example_1_title) {
        return TemplateExampleOne(title: child, description: description);
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
            title: child.title,
            description: child.description.trim().isNotEmpty ? child.description : null,
            onTap: () {
              Navigator.of(context).push(_MyPageRoute<void>(builder: (context) {
                return widget;
              }));
            }),
      );
    }
    return ExpansionTile(
      title: Text(parent.title, style: Theme.of(context).textTheme.titleMedium),
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
/// [title] 以共同顯示的文字作為 [Hero] 標記防呆。
class _ListTileHero extends StatelessWidget {

  static final DESCRIPTION_MAX_LINES = 2;

  final String title;
  final String? description;
  final GestureTapCallback? onTap;
  const _ListTileHero({
    required this.title, required this.onTap, this.description
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
        tag: title, // AbsExamplePage.hero_key_title,
        // Don't forget Material(), see example from:
        // https://docs.flutter.dev/ui/animations/hero-animations
        child: Material(
          child: Text(
            title, style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
      subtitle: description != null && description!.trim().isNotEmpty ? Hero(
        tag: description!,  // AbsExamplePage.hero_key_description,
        // Don't forget Material(), see example from:
        // https://docs.flutter.dev/ui/animations/hero-animations
        child: Material(
          child: Text(description!, maxLines: DESCRIPTION_MAX_LINES, overflow: TextOverflow.ellipsis),
        ),
      ) : null,
      onTap: onTap,
    );
  }
}

