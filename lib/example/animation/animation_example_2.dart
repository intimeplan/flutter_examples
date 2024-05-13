import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/example_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// [AnimatedContainer] showcase
///
class AnimationExampleTwo extends AbsExamplePage {
  const AnimationExampleTwo(
      {super.key, required super.title, super.description});

  @override
  Widget build(BuildContext context) {
    return _AnimationExampleTwo(title: title, description: description);
  }
}

class _AnimationExampleTwo extends StatefulWidget {
  final String title;
  final String? description;

  const _AnimationExampleTwo({required this.title, this.description});

  @override
  State createState() {
    return _AnimationExampleTwoState();
  }
}

class _AnimationExampleTwoState extends State<_AnimationExampleTwo>
    with TickerProviderStateMixin {
  /// Professional typists type at speeds in second: 120 x 5 / 60 = 10 character
  /// https://en.wikipedia.org/wiki/Words_per_minute#Alphanumeric_entry
  static const double characters_typed_in_second = 10;

  late final AnimationController _controller;
  late String _description;
  bool isAnimationIdle() =>
      !_controller.isAnimating || _controller.isCompleted || _controller.isDismissed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _description = AppLocalizations.of(context)!.wiki_universe;
    _description = _description;
    _controller.duration = Duration(
      milliseconds: (
        _description.length / characters_typed_in_second * 1000
      ).toInt()
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MyPage(
      title: widget.title,
      description: widget.description,
      body: getBody(),
      fab: getFab(),
    );
  }


  int _maxLines = 1;

  Widget? getBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // check stack widget safe size
        var safe_size = min(constraints.maxWidth, constraints.maxHeight);
        return Container(
          width: safe_size,
          height: safe_size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset("assets/480px-Hubble_ultra_deep_field.jpg"),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        AppLocalizations.of(context)!.wiki_universe_title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints){
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget? child) {
                            int _len = (_description.length * _controller.value).toInt();
                            String text = _description.substring(0, _len);
                            TextStyle? style = Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white
                            );
                            TextPainter painter = TextPainter(
                              text: TextSpan(text: text, style: style),
                              textDirection: TextDirection.ltr,
                            );

                            // Restrict max lines or warning out of boundary
                            painter.layout(maxWidth: constraints.maxWidth);
                            int lines = painter.computeLineMetrics().length;
                            if(painter.size.height < constraints.maxHeight) {
                              _maxLines = max(lines, 1);
                            }
                            return Text(
                              text, style: style,
                              overflow: TextOverflow.ellipsis,
                              // when it works with overflow: define value or be 1.
                              maxLines: _maxLines,
                            );
                          },
                        );
                      })
                    )
                  ],
                ),
              ),
            ],
          )
        );
      }
    );
  }

  Widget getFab() {
    return FloatingActionButton(
      child:
        Icon(isAnimationIdle() ? Icons.play_arrow : Icons.replay),
      onPressed: () {
        setState(() {
          if (isAnimationIdle()) {
            _controller.forward();
          } else {
            _controller.reset();
          }
        });
      }
    );
  }



}

class _MyPage extends AbsExamplePage {
  final Widget? body, fab;
  const _MyPage({
    required super.title,
    super.description,
    this.body,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: getAppBar(context, constraints.maxWidth),
        body: body,
        floatingActionButton: fab,
      );
    });
  }
}
