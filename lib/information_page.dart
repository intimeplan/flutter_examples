import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import'dart:io' show Platform;


class InformationPage extends StatelessWidget {

  List<String>? _titles;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    _titles ??= [
      AppLocalizations.of(context)!.information_source_title,
      AppLocalizations.of(context)!.information_store_title,
      AppLocalizations.of(context)!.information_privacy_title,
    ];

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
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
            (context, index) {
              var title = _titles![index];
              if(title == AppLocalizations.of(context)!.information_source_title) {
                return ListTile(
                  title: Text(title),
                  onTap: () async {
                    await launchUrl(Uri.parse(
                      AppLocalizations.of(context)!.information_source_content_url)
                    );
                  },
                );
              }
              if(title == AppLocalizations.of(context)!.information_store_title) {
                return ListTile(
                  title: Text(title),
                  onTap: (){
                    if(Platform.isAndroid) {
                      // Todo
                    }
                    else if(Platform.isIOS) {
                      // Todo
                    }
                  },
                );
              }
              if(title == AppLocalizations.of(context)!.information_privacy_title) {
                return ListTile(
                  title: Text(title),
                  onTap: () async {
                    await launchUrl(Uri.parse(
                        AppLocalizations.of(context)!.information_privacy_content_url)
                    );
                  },
                );
              }
              return SizedBox();
            },
            childCount: _titles != null ? _titles!.length : 0
          ),
        ),
      ]
    );

  }

}
