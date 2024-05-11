import 'dart:math';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: getAppBar(context),
      body: getBody(),
    );
  }

  Widget? getBody() {
    return LayoutBuilder(
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
                        child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg")
                    ),
                    SizedBox(
                        width: constraints.maxWidth - safe_size, height: safe_size,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            AppLocalizations.of(context)!.wiki_universe,
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
                      child: Image.asset("assets/480px-Hubble_ultra_deep_field.jpg")
                  ),
                  SizedBox(
                      width: safe_size, height: constraints.maxHeight - safe_size,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          AppLocalizations.of(context)!.wiki_universe,
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
    );
  }


}
