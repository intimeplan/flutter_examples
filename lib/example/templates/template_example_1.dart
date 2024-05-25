import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';
import 'package:provider/provider.dart';


/// Another code template for listening to scroll events.
///
/// Typically we implement a [NotificationListener] and what to do on top widget:
/// ```dart
/// NotificationListener<ScrollNotification>(
///   onNotification: (notification) {
///     onScrolling(notification);
/// ```
/// Now we implement what to do on bottom widget with [Consumer] type [ScrollEventProxy]
///
class ScrollBroadcast extends StatelessWidget {

  final Widget child;
  final ScrollEventProxy proxy = ScrollEventProxy();

  ScrollBroadcast({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollEventProxy>(
      create:  (context) => proxy,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          proxy.send(notification);
          return true;
        },
        child: child,
      ),
    );
  }
}

class ScrollEventProxy extends ChangeNotifier {
  ScrollNotification? event;
  void send(ScrollNotification notification) {
    event = notification;
    notifyListeners();
  }
}

///
/// [TemplateExampleOne] showcase
///
class TemplateExampleOne extends StatelessWidget {

  /// List item leading colors pattern
  static final List<Color> _colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple];
  final String title;
  final String? description;

  const TemplateExampleOne({
    super.key, required this.title, this.description
  });

  @override
  Widget build(BuildContext context) {
    return ScrollBroadcast(
      child: LayoutBuilder(builder: (context, constraints){
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _sliverAppBar(context, constraints.maxWidth),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ListTile(
                      leading: Container(
                        width: 24, height: 24,
                        color: _colors[index%_colors.length],
                      ),
                      title: Text('$index'),
                      onTap: (){},
                    );
                  },
                    childCount: 1000,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: MyFloatingActionButton(),
        );
      })
    );
  }

  /// [maxWidth] to measure text height to set [AppBar.bottom] preferred size
  SliverAppBar _sliverAppBar(BuildContext context, double maxWidth){
    return SliverAppBar(
      floating: true, snap: true,
      title: Hero(
        tag: title,
        child: Material(
          child: Text(title,
            // define from [AppBar#titleTextStyle]
            style: AppBarTheme.of(context).titleTextStyle ?? Theme.of(context).textTheme.titleLarge,
          ),
        )
      ),
      bottom: description != null && description!.trim().isNotEmpty ? PreferredSize(
        preferredSize: Size.fromHeight(
          _textSize(description!,
            Theme.of(context).textTheme.bodyMedium!,
            AbsExamplePage.description_max_lines,
            maxWidth - 32           // maxWidth - (EdgeInsets left + right)
          ).height + 32             // height + (EdgeInsets top + bottom)
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: AlignmentDirectional.topStart,
          child: Hero(
            tag: description!,
            child: Material(
              child: Text(description!, maxLines: AbsExamplePage.description_max_lines, overflow: TextOverflow.ellipsis,),
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


class MyFloatingActionButton extends StatefulWidget {

  const MyFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> createState() {
    return MyFloatingActionButtonState();
  }
}

class MyFloatingActionButtonState extends State<MyFloatingActionButton> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollEventProxy>(
      builder: (BuildContext context, ScrollEventProxy proxy, Widget? child) {
        if(proxy.event != null)
          onFabScrolling(proxy.event!);
        return child!;
      },
      child: getFab(),
    );
  }

  Widget getFab() {
    return AnimatedScale(
      scale: _visibility ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: FloatingActionButton(
        child: const Icon(Icons.visibility),
        onPressed: (){ }
      ),
    );
  }

  static const int _OFFSET_TO_HIDE = 80;
  static const int _OFFSET_TO_SHOW = -40;
  bool _visibility = true;
  double _scrollingPixels = 0;

  void onFabScrolling(ScrollNotification notification) {
    var metrics = notification.metrics;
    var nowPixels = metrics.pixels;
    // When fab is visible
    if (_visibility) {
      // Hide fab when scroll down a distance
      if (nowPixels - _scrollingPixels > _OFFSET_TO_HIDE) {
        postVisibility(false);
      }
      // Always relocate to minimum whether scroll up or down
      _scrollingPixels = min(nowPixels, _scrollingPixels);
    // When fab is hide
    } else {
      // Show fab when scroll up a distance
      if (nowPixels - _scrollingPixels < _OFFSET_TO_SHOW) {
        postVisibility(true);
      }
      // Always relocate to maximum whether scroll up or down
      _scrollingPixels = max(nowPixels, _scrollingPixels);
    }
  }

  void postVisibility(bool visibility) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _visibility = visibility;
      });
    });
  }
}



