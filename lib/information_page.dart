import 'package:flutter/material.dart';
import 'package:flutter_example/example/animation/animation_example_1.dart';
import 'package:flutter_example/example/animation/animation_example_2.dart';
import 'package:flutter_example/example/interaction/interaction_example_1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'example/layouts/layout_example_1.dart';
import 'example/layouts/layout_example_2.dart';
import 'example/templates/template_example_1.dart';


class InformationPage extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // Add the app bar and list of items as slivers in the next steps.
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            // Provide a standard title.
            title: Text(AppLocalizations.of(context) != null ? AppLocalizations.of(context)!.information_page_title : ""),
            // Allows the user to reveal the app bar if they begin scrolling
            // back up the list of items.
            floating: true,
            // // Display a placeholder widget to visualize the shrinking size.
            // flexibleSpace: Placeholder(),
            // // Make the initial height of the SliverAppBar larger than normal.
            // expandedHeight: 200,
          ),
          // Next, create a SliverList
        ]
    );
  }

}
