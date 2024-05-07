import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';


///
/// [AnimatedContainer] showcase
///
class LayoutExampleOne extends StatefulWidget {

  final AppBarHero appbar;

  const LayoutExampleOne({
    super.key,
    required this.appbar
  });

  @override
  State createState() {
    return _AnimationExampleOneState();
  }

}

class _AnimationExampleOneState extends State<LayoutExampleOne> {

  bool _animated = false;

  @override
  Widget build(BuildContext context) {
    return BaseExamplePage(
      appbar: widget.appbar,
      body: getBody(),
      fab: getFab(),
    );
  }

  Widget? getBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // check stack widget safe size
        var size = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.loose,
            children: [
              // animate image by container
              Align(
                alignment: Alignment.topLeft,
                child: AnimatedContainer(
                  clipBehavior: Clip.hardEdge,
                  color: !_animated ? Colors.yellow : Colors.blue,
                  padding:  EdgeInsets.all(!_animated ? 8 : 16),
                  width: !_animated ? size/2 : size,
                  height: !_animated ? size/2 : size,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox.expand(
                      child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg")
                  ),
                ),
              ),
              // animate text by container
              Align(
                alignment: Alignment.topRight,
                child: AnimatedContainer(
                  padding:  const EdgeInsets.all(16),
                  width: !_animated ? 0 : size,
                  height: size,
                  alignment: !_animated ? Alignment.bottomRight : Alignment.bottomLeft,
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.linear,
                  child: const Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                      "The Hubble Ultra-Deep Field image shows some of the most remote galaxies visible to present technology."
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget? getFab() {
    return FloatingActionButton(
      child: Icon(!_animated ? Icons.play_arrow : Icons.replay),
      onPressed: (){
        setState(() {
          _animated = ! _animated;
        });
      }
    );
  }
}
