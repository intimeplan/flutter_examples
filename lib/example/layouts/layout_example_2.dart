import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/example_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// [LayoutExampleTwo] showcase
///
class LayoutExampleTwo extends AbsExamplePage {

  const LayoutExampleTwo({
    super.key, required super.title, super.description
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      return Scaffold(
        appBar: getAppBar(context, constraints.maxWidth),
        body: getBody(),
      );
    });
  }

  Widget? getBody() {
    return LayoutBuilder(
        builder: (context, constraints) {
          // check stack widget safe size
          var safe_size = min(constraints.maxWidth, constraints.maxHeight);

          // find safe fibonacci ordinal
          List<int> arrayFibonacci = [];
          while(true) {
            int last = arrayFibonacci.isNotEmpty ? arrayFibonacci.last : 0;
            int now = fibonacci(arrayFibonacci.length+1);
            if(last + now > safe_size) {
              break;
            }
            arrayFibonacci.add(now);
          }

          return Container(
            alignment: Alignment.center,
            child: FibonacciRow(
              ordinal: arrayFibonacci.length,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          );
        }
    );
  }

}

abstract class FibonacciWidget extends StatelessWidget {

  static const double decoration_bold = 1;
  static const double deault_font_size = 22;

  final int ordinal;
  final MainAxisAlignment mainAxisAlignment;
  const FibonacciWidget({super.key, required this.ordinal, required this.mainAxisAlignment});
}

class FibonacciRow extends FibonacciWidget {

  const FibonacciRow({super.key, required super.ordinal, required super.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {

    TextStyle? style = Theme.of(context).textTheme.bodySmall;
    double min_size = style != null && style.fontSize != null ? style.fontSize! : FibonacciWidget.deault_font_size;

    List<Widget> children = [];
    double size = fibonacci(ordinal).toDouble();
    if(size > min_size) {
      children.add(Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: FibonacciWidget.decoration_bold, color: Colors.black),
        ),
        child: Text(size.toInt().toString(), style: style),
      ));
    }
    double size_down = fibonacci(ordinal - 1).toDouble();
    if(size_down > min_size) {
      children.add(FibonacciColumn(
          ordinal: ordinal-1,
          mainAxisAlignment: mainAxisAlignment,
        ),
      );
    } else {
      children.add(Column());
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: mainAxisAlignment == MainAxisAlignment.start ? CrossAxisAlignment.start: CrossAxisAlignment.end,
      children: mainAxisAlignment == MainAxisAlignment.start ? children : children.reversed.toList(),
    );
  }

}

class FibonacciColumn extends FibonacciWidget {

  const FibonacciColumn({super.key, required super.ordinal, required super.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {

    TextStyle? style = Theme.of(context).textTheme.bodySmall;
    double min_size = style != null && style.fontSize != null ? style.fontSize! : FibonacciWidget.deault_font_size;

    List<Widget> children = [];
    double size = fibonacci(ordinal).toDouble();
    if(size > min_size) {
      children.add(Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: FibonacciWidget.decoration_bold, color: Colors.black),
        ),
        child: Text(size.toInt().toString(), style: style),
      ));
    }
    double size_down = fibonacci(ordinal - 1).toDouble();
    if(size_down > min_size) {
      children.add(FibonacciRow(
          ordinal: ordinal-1,
          mainAxisAlignment: mainAxisAlignment == MainAxisAlignment.start
              ? MainAxisAlignment.end : MainAxisAlignment.start,
        ),
      );
    }
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: mainAxisAlignment == MainAxisAlignment.start ? CrossAxisAlignment.end: CrossAxisAlignment.start,
      children: mainAxisAlignment == MainAxisAlignment.start ? children : children.reversed.toList(),
    );
  }


}

/// [ordinal] should start from 1
/// return fibonacci value of
int fibonacci(int ordinal) {
  if (ordinal <= 1) {
    return ordinal;
  } else {
    return fibonacci(ordinal - 1) + fibonacci(ordinal - 2);
  }
}