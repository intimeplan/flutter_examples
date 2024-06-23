import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NetworkExampleTwo extends AbsExamplePage {

  const NetworkExampleTwo({
    super.key, required super.title, super.description
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _NetworkExampleTwo(appBar: getSliverAppBar(context, constraints.maxWidth));
    });

  }
}


class _NetworkExampleTwo extends StatefulWidget {

  final SliverAppBar appBar;

  const _NetworkExampleTwo({required this.appBar});

  @override
  State createState() {
    return _NetworkExampleTwoState();
  }
}



class _NetworkExampleTwoState extends State<_NetworkExampleTwo>
    with SingleTickerProviderStateMixin {

  final _imageController = TextEditingController(
    text: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Hubble_ultra_deep_field.jpg"
  );
  var _clearButtonVisibility = true;

  late AnimationController _download_animator;
  late Animation<double> _download_animation;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Create an animation controller
    _download_animator = AnimationController(
      vsync: this, // vsync is set to this for performance reasons
      duration: Duration(seconds: 2), // Set the duration of the animation
    );
    // Create a Tween for the rotation angle
    _download_animation = Tween<double>(
      begin: 0, // Start rotation angle
      end: 2 * math.pi, // End rotation angle (2 * pi for a full circle)
    ).animate(_download_animator);
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is disposed
    _download_animator.dispose();
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
        SliverToBoxAdapter(
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.network_example_2_title_url,
              style: Theme.of(context).textTheme.titleMedium
            ),
            subtitle: TextFormField(
              controller: _imageController,
              // Perform actions based on the entered text
              // You can do validation, update other UI elements, etc.
              onChanged: (text) {
                if(_clearButtonVisibility && text.isEmpty){
                  setState(() {
                    _clearButtonVisibility = false;
                  });
                  return;
                }
                if( ! _clearButtonVisibility && ! text.isEmpty){
                  setState(() {
                    _clearButtonVisibility = true;
                  });
                  return;
                }
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _clearButtonVisibility = false;
                      _imageController.clear();
                    });
                  },
                  icon: Visibility(
                    visible: _clearButtonVisibility,
                    child: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(AppLocalizations.of(context)!.network_example_2_title_preview,
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            subtitle: _imageFile != null
              ? InkWell(
                onLongPress: () async {
                  if(_imageFile == null) {
                    _snackBar(context, AppLocalizations.of(context)!.network_example_2_hint_no_image);
                    return;
                  }
                  final result = await Share.shareXFiles(
                    [
                      XFile(_imageFile!.path)
                    ],
                    text: AppLocalizations.of(context)!.network_example_2_title_send
                  );
                  if (result.status == ShareResultStatus.unavailable) {
                    // Don't use 'BuildContext's across async gaps,
                    // guarded by an unrelated 'mounted' check. (Documentation)
                    // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                    if (context.mounted) {
                      _snackBar(context, AppLocalizations.of(context)!.network_example_2_hint_unable_share);
                    }
                  }
                },
                child: Card.filled(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Adjust corner radius as desired
                  ),
                  child: Image(
                    image: FileImage(_imageFile!),
                    errorBuilder: (context, error, stackTrace){
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(error.toString()),
                        ),
                      );
                    },
                  ),
                ),
              )
              : Card.filled(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Adjust corner radius as desired
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.preview),
                  ),
                ),
          )
        )
      ]
    );
  }


  Widget getFab() {
    return Builder(
      builder: (context) {
        return _download_animator.isAnimating
          ? FloatingActionButton(
            onPressed: () {  },
            child: AnimatedBuilder(
              animation: _download_animation,
              builder: (context, child) {
                // Use Transform.rotate to rotate the Image based on the animation value
                return Transform.rotate(
                  angle: _download_animation.value,
                  child: const Icon(Icons.autorenew),
                );
              },
            ),
          )
          : FloatingActionButton(
            child: const Icon(Icons.download),
            onPressed: () async {
              await _imageFile?.delete();
              _imageFile = null;
              setState(() {
                _download_animator.repeat();
              });
              _imageFile =  await _downloadFile(_imageController.value.text, DateTime.now().millisecondsSinceEpoch.toString());
              setState(()  {
                _download_animator.reset();
              });
            }
          );
      }
    );
  }

  void _snackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<File?> _downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Add file extension to help correct response when sending
      // https://stackoverflow.com/questions/23714383/what-are-all-the-possible-values-for-http-content-type-header
      String type = response.headers['content-type'] ?? 'text/plain';
      if(type.startsWith("image/")){
        fileName += ".${type.substring("image/".length)}";
      }
      final directory = await getTemporaryDirectory();
      final filePath = File('${directory.path}/$fileName');
      File file = await filePath.writeAsBytes(response.bodyBytes, flush: true);
      return file;
    } else {
      return null;
    }
  }



}

