import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        SliverToBoxAdapter(
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text(AppLocalizations.of(context)!.information_source_title),
            onTap: () async {
              await launchUrl(Uri.parse(
                  AppLocalizations.of(context)!.information_source_content_url)
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            leading: Icon(Icons.sports_esports_outlined),
            title: Text(AppLocalizations.of(context)!.information_store_title),
            onTap: () async {
              if(Platform.isAndroid) {
                // Alpha Channel
                await launchUrl(Uri.parse(
                    "https://play.google.com/apps/testing/app.intimeplan.flutterexp"
                  )
                );
              }
              else if(Platform.isIOS) {
                // TestFlight
                await launchUrl(Uri.parse(
                    "https://testflight.apple.com/join/E50kpsep"
                  )
                );
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text(AppLocalizations.of(context)!.information_privacy_title),
            onTap: () async {
              await launchUrl(Uri.parse(
                AppLocalizations.of(context)!.information_privacy_content_url)
              );
            },
          ),
        ),
      ],
    );

  }

}
