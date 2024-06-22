import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


///
/// [TemplateExampleTwo] showcase
/// This Example is base on the official code sample
/// https://api.flutter.dev/flutter/material/ColorScheme-class.html
///
class TemplateExampleTwo extends AbsExamplePage {

  const TemplateExampleTwo({
    super.key, required super.title, super.description
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ColorSchemeExample(
        title: super.title,
        maxWidth: constraints.maxWidth,
        description: super.description
      );
    });

  }

}

// Default divider which used in the scroll view
const Widget _divider = SizedBox(height: 8);

class ColorSchemeExample extends StatefulWidget {

  final String title;
  final String? description;
  final double maxWidth;

  const ColorSchemeExample({
    super.key, required this.title, required this.maxWidth, this.description
  });

  @override
  State<ColorSchemeExample> createState() => _ColorSchemeExampleState();
}

class _ColorSchemeExampleState extends State<ColorSchemeExample> {

  Brightness? _brightness;

  // default value is flutter logo color
  // https://flutter.dev/brand
  Color _color = Color(0x00027DFD);
  final _colorEditor = TextEditingController(text: "#027DFD");

  @override
  Widget build(BuildContext context) {
    _brightness ??= MediaQuery.of(context).platformBrightness;
    var description = widget.description;
    return Theme(
      data: ThemeData(
        // AppBar background work with ColorScheme.fromSeed
        // when useMaterial3 = false
        // useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _color,
          brightness: _brightness!,
        )
      ),
      child: Builder(
        builder: (BuildContext context) => Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Hero(
                    tag: widget.title,  // AbsExamplePage.hero_key_description,
                    child: Material(
                      child: Text(
                        widget.title,
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
                          AbsExamplePage.description_max_lines,
                          widget.maxWidth - 32           // maxWidth - (EdgeInsets left + right)
                      ).height + 32             // height + (EdgeInsets top + bottom)
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    alignment: AlignmentDirectional.topStart,
                    child: Column(
                      children: [
                        Hero(
                            tag: description!,  // AbsExamplePage.hero_key_description,
                            child: Material(
                              child: Text(description!, maxLines: AbsExamplePage.description_max_lines, overflow: TextOverflow.ellipsis,),
                            )
                        ),
                      ],
                    )
                  )
                ) : null,
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: const Text('Color Seed'),
                  ),
                  subtitle:  TextFormField(
                    controller: _colorEditor,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        var color = _toColor(value);
                        if(color == null) {
                          _snackbar(context, AppLocalizations.of(context)!.template_example_2_hint_hex_color_short);
                          return;
                        }
                        _color = color;
                      });
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  title: const Text('Brightness'),
                  trailing: Switch(
                    value: _brightness == Brightness.light,
                    onChanged: (bool value) {
                      setState(() {
                        _brightness = value ? Brightness.light : Brightness.dark;
                      });
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(1, (int index) {
                    return ColorSchemeVariantColumn(
                      selectedColor: _color,
                      brightness: _brightness!,
                      maxWidth: widget.maxWidth,
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        ),
      ),
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


  ///
  /// [text] : Hex Color Expression (no alpha channel)
  ///
  bool _isHexColor(String text) {
    final regex = RegExp(r"^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$");
    return regex.hasMatch(text);
  }

  Color? _toColor(String text) {
    if( ! _isHexColor(text)){
      return null;
    }
    var radix = 16;
    // Normalize case: #RGB to #RRGGBB
    if (text.length == 4) {
      // Simple solution
      text = "#${text[1]}${text[1]}${text[2]}${text[2]}${text[3]}${text[3]}";
      // Formula solution
      // final R = int.tryParse(text[1], radix: radix) ?? 0;
      // final G = int.tryParse(text[2], radix: radix) ?? 0;
      // final B = int.tryParse(text[3], radix: radix) ?? 0;
      // text = "#${
      //   R.toRadixString(radix).padLeft(2, R.toRadixString(radix))
      // }${
      //   G.toRadixString(radix).padLeft(2, G.toRadixString(radix))
      // }${
      //   B.toRadixString(radix).padLeft(2, B.toRadixString(radix))
      // }";
    }
    int value = int.parse(text.replaceAll('#', ''), radix: radix);
    return Color(value);
  }

  void _snackbar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: scaffold.hideCurrentSnackBar,
        // ),
      ),
    );
  }
}

class ColorSchemeVariantColumn extends StatelessWidget {
  const ColorSchemeVariantColumn({
    super.key,
    required this.brightness,
    required this.selectedColor,
    required this.maxWidth,
  });

  final Brightness brightness;
  final Color selectedColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: maxWidth),
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16),
            //   child: Text(
            //     "",
            //     schemeVariant.name == 'tonalSpot'
            //         ? '${schemeVariant.name} (Default)'
            //         : schemeVariant.name,
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColorSchemeView(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: selectedColor,
                  brightness: brightness,
                ),
              ),
            ),
          ],
        ));
  }
}

class ColorSchemeView extends StatelessWidget {

  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorGroup(children: <ColorChip>[
          ColorChip('primary', colorScheme.primary, colorScheme.onPrimary),
          ColorChip('onPrimary', colorScheme.onPrimary, colorScheme.primary),
          ColorChip('primaryContainer', colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer),
          ColorChip(
            'onPrimaryContainer',
            colorScheme.onPrimaryContainer,
            colorScheme.primaryContainer,
          ),
        ]),
        _divider,
        ColorGroup(children: <ColorChip>[
          ColorChip(
              'secondary', colorScheme.secondary, colorScheme.onSecondary),
          ColorChip(
              'onSecondary', colorScheme.onSecondary, colorScheme.secondary),
          ColorChip(
            'secondaryContainer',
            colorScheme.secondaryContainer,
            colorScheme.onSecondaryContainer,
          ),
          ColorChip(
            'onSecondaryContainer',
            colorScheme.onSecondaryContainer,
            colorScheme.secondaryContainer,
          ),
        ]),
        _divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            ColorChip(
                'onTertiary', colorScheme.onTertiary, colorScheme.tertiary),
            ColorChip(
              'tertiaryContainer',
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
            ),
            ColorChip(
              'onTertiaryContainer',
              colorScheme.onTertiaryContainer,
              colorScheme.tertiaryContainer,
            ),
          ],
        ),
        _divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('error', colorScheme.error, colorScheme.onError),
            ColorChip('onError', colorScheme.onError, colorScheme.error),
            ColorChip('errorContainer', colorScheme.errorContainer,
                colorScheme.onErrorContainer),
            ColorChip('onErrorContainer', colorScheme.onErrorContainer,
                colorScheme.errorContainer),
          ],
        ),
        _divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('outline', colorScheme.outline, null),
            ColorChip('shadow', colorScheme.shadow, null),
            ColorChip('inverseSurface', colorScheme.inverseSurface,
                colorScheme.onInverseSurface),
            ColorChip('onInverseSurface', colorScheme.onInverseSurface,
                colorScheme.inverseSurface),
            ColorChip('inversePrimary', colorScheme.inversePrimary,
                colorScheme.primary),
          ],
        ),
      ],
    );
  }
}

class ColorGroup extends StatelessWidget {

  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(clipBehavior: Clip.antiAlias, child: Column(children: children)),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip(this.label, this.color, this.onColor, {super.key});

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Expanded>[
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}
