import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';

///
/// [AnimatedContainer] showcase
///
class AnimationExampleThree extends AbsExamplePage {
  const AnimationExampleThree(
      {super.key, required super.title, super.description});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _AnimationExampleThree(appBar: getSliverAppBar(context, constraints.maxWidth));
    });

  }
}


class _AnimationExampleThree extends StatefulWidget {

  final SliverAppBar appBar;

  const _AnimationExampleThree({required this.appBar});

  @override
  State createState() {
    return _AnimationExampleThreeState();
  }
}



class _AnimationExampleThreeState extends State<_AnimationExampleThree>
    with SingleTickerProviderStateMixin {

  static const int ANIMATION_SECONDS = 6;
  static const (double, double) TWEEN_RANGE = (30, 120);
  /// [Slider] min max should cover the tween range,
  /// otherwise the value will cross the boundary in some curves like Elastic, Bounce etc
  static const (double, double) SLIDER_RANGE = (0, 150);

  static const List<(String, Curve)> ITEMS = [

    ("Linear", Curves.linear),
    ("Decelerate", Curves.decelerate),

    ("FastLinearToSlowEaseIn", Curves.fastLinearToSlowEaseIn),
    ("FastEaseInToSlowEaseOut", Curves.fastEaseInToSlowEaseOut),

    ("FastOutSlowIn", Curves.fastOutSlowIn),
    ("SlowMiddle", Curves.slowMiddle),

    // BounceInOut
    ("BounceIn", Curves.bounceIn),
    ("BounceOut", Curves.bounceOut),
    ("BounceInOut", Curves.bounceInOut),

    // ElasticInOut
    ("ElasticIn", Curves.elasticIn),
    ("ElasticOut", Curves.elasticOut),
    ("ElasticInOut", Curves.elasticInOut),

    // Ease
    ("Ease", Curves.ease),

    // EaseIn
    ("EaseIn", Curves.easeIn),
    ("EaseInToLinear", Curves.easeInToLinear),
    ("EaseInSine", Curves.easeInSine),
    ("EaseInQuad", Curves.easeInQuad),
    ("EaseInCubic", Curves.easeInCubic),
    ("EaseInQuart", Curves.easeInQuart),
    ("EaseInQuint", Curves.easeInQuint),
    ("EaseInExpo", Curves.easeInExpo),
    ("EaseInCirc", Curves.easeInCirc),
    ("EaseInBack", Curves.easeInBack),

    // EaseOut
    ("EaseOut", Curves.easeOut),
    ("LinearToEaseOut", Curves.linearToEaseOut),
    ("EaseOutSine", Curves.easeOutSine),
    ("EaseOutQuad", Curves.easeOutQuad),
    ("EaseOutCubic", Curves.easeOutCubic),
    ("EaseOutQuart", Curves.easeOutQuart),
    ("EaseOutQuint", Curves.easeOutQuint),
    ("EaseOutExpo", Curves.easeOutExpo),
    ("EaseOutCirc", Curves.easeOutCirc),
    ("EaseOutBack", Curves.easeOutBack),

    // EaseInOut
    ("EaseInOut", Curves.easeInOut),
    ("EaseInOutSine", Curves.easeInOutSine),
    ("EaseInOutQuad", Curves.easeInOutQuad),
    ("EaseInOutCubic", Curves.easeInOutCubic),
    ("EaseInOutCubicEmphasized", Curves.easeInOutCubicEmphasized),
    ("EaseInOutQuart", Curves.easeInOutQuart),
    ("EaseInOutQuint", Curves.easeInOutQuint),
    ("EaseInOutExpo", Curves.easeInOutExpo),
    ("EaseInOutCirc", Curves.easeInOutCirc),
    ("EaseInOutBack", Curves.easeInOutBack),

  ];

  final List<(String, Curve)> _items = [];
  late AnimationController _controller;
  bool isAnimationCanFowarding() =>
      _controller.status != AnimationStatus.forward && _controller.status != AnimationStatus.completed;

  @override
  void initState() {
    super.initState();
    _items.addAll(ITEMS);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: ANIMATION_SECONDS),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(widget.appBar),
      floatingActionButton: getFab(),
    );
  }


  Widget? getBody(SliverAppBar appBar) {
    return CustomScrollView(
      slivers: [
        widget.appBar,
        SliverReorderableList(
          itemBuilder: (BuildContext context, int index) {
            var name = _items[index].$1.toString();
            return ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              key: Key(name),
              title: Row(
                children: [
                  Expanded(
                    child: Text(name),
                  ),
                  ReorderableDragStartListener(
                    key: Key(name),
                    index: index,
                    child: IconButton(
                      icon: Icon(Icons.drag_indicator),
                      onPressed: () {  },
                    ),
                  ),
                ],
              ),
              subtitle: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Slider(
                    min: SLIDER_RANGE.$1, max: SLIDER_RANGE.$2,
                    value: Tween<double>(begin: TWEEN_RANGE.$1, end: TWEEN_RANGE.$2).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: _items[index].$2,
                        )
                    ).value, onChanged: (value) {  },
                  );
                },
              ),
              // TweenAnimationBuilder can't support when to forward and reverse
              // subtitle: TweenAnimationBuilder<double>(
              //   duration: const Duration(seconds: ANIMATION_SECONDS),
              //   curve: _items[index].$2,
              //   tween: Tween<double>(begin: TWEEN_RANGE.$1, end: TWEEN_RANGE.$2),
              //   builder: (context, value, child) => Slider(
              //     min:  TWEEN_RANGE.$1, max:  TWEEN_RANGE.$2,
              //     value: value, onChanged: (value) {  },
              //   ),
              // ),
            );
          },
          itemCount: _items.length,
          onReorder: (oldIndex, newIndex){
            setState(() {
              // 1. the new index base on old list
              // 2. drag to the greater index, the original item gone cause index offset -1
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              _items.insert(newIndex, _items.removeAt(oldIndex));
            });
          },
        ),
      ]
    );
  }

  Widget getFab() {
    return FloatingActionButton(
      child: Icon(isAnimationCanFowarding() ? Icons.play_arrow : Icons.replay),
      onPressed: () {
        setState(() {
          if (isAnimationCanFowarding()) {
            switch(_controller.status) {
              case AnimationStatus.dismissed:
                _controller.forward();
                break;
              case AnimationStatus.reverse:
                _controller.forward();
                break;
              case AnimationStatus.completed:
              case AnimationStatus.forward:
            }
          } else {
            _controller.reverse();
          }
        });
      }
    );
  }


}

