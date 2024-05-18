// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example/example_list.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// File Key Note:
/// 1. [ExampleConfig]
/// 2. [ExampleList]
/// 3. [BaseExamplePage]
class _Note {}
class _MockBuildContext extends Mock implements BuildContext {}


void main() {

  testExamples_allTitleUnique();
  testExamplePage_hasHeroTitle();
}



Future<BuildContext> pumpWidget(WidgetTester tester, Widget? widget) async {
  // AppLocalizations 必須初始化才能使用
  await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate,],
      home: Container(
        child: widget,
      )
  ));
  // 取得 context 方式
  return tester.element(find.byType(Container).first);
}

/// All Example Page require a hero title for page transition
void testExamplePage_hasHeroTitle(){

  testWidgets('testExamplePage_hasHeroTitle', (WidgetTester tester) async {

    // config 初始化
    var context = await pumpWidget(tester, null);
    var config = ExampleConfig(context: context);

    // 開始測試
    for (var item in config.list) {
      Example parent = item.$1;
      List<Example> children = item.$2;
      for (var child in children) {
        // pump widget
        var widget = config.build(parent.title, child.title, child.description);
        expect(widget != null, true);
        context = await pumpWidget(tester, widget!);
        config = ExampleConfig(context: context);   // config context needs updated after pump widget

        // first hero text should always in appbar
        var hero = find.byType(Hero).evaluate().first.widget as Hero;
        expect(hero.tag, child.title);
        var text = find.descendant(
            of: find.byWidget(hero), matching: find.byType(Text)
        ).evaluate().first.widget as Text;
        expect(text.data, child.title);
      }
    }
  });
}

void testExamples_allTitleUnique(){
  testWidgets('testExamples_allTitleUnique', (WidgetTester tester) async {

    // config 初始化
    var context = await pumpWidget(tester, null);
    var config = ExampleConfig(context: context);

    List text = [];
    for (var item in config.list) {
      Example parent = item.$1;
      List<Example> children = item.$2;
      // check parents all unique
      expect(text.contains(parent.title), false);
      text.add(parent.title);
      for (var child in children) {
        // check child all unique
        expect(text.contains(child.title), false);
        text.add(child.title);
        if(child.description.trim().isNotEmpty) {
          expect(text.contains(child.description), false);
          text.add(child.description);
        }
      }
    }
  });
}
