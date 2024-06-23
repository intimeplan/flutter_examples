import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/example_list.dart';
import 'package:http/http.dart' as http;


class NetworkExampleOne extends AbsExamplePage {

  const NetworkExampleOne({
    super.key, required super.title, super.description
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _NetworkExampleOne(appBar: getSliverAppBar(context, constraints.maxWidth));
    });

  }
}


class _NetworkExampleOne extends StatefulWidget {

  final SliverAppBar appBar;

  const _NetworkExampleOne({required this.appBar});

  @override
  State createState() {
    return _NetworkExampleOneState();
  }
}



class _NetworkExampleOneState extends State<_NetworkExampleOne>
    with SingleTickerProviderStateMixin {

  static const List<String> HTTP_METHODS = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];
  static const double HARMONY_PADDING = 16;

  var _apiController = TextEditingController(
    text: "https://jsonplaceholder.typicode.com/todos/1"
  );
  var _bodyController = TextEditingController();
  var _clearButtonVisibility = true;
  var _httpMethod = "GET";
  var _response = "";

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
            title: Text("REST API URL",
              style: Theme.of(context).textTheme.titleMedium
            ),
            subtitle: TextFormField(
              controller: _apiController,
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
                      _apiController.clear();
                    });
                  },
                  icon: Visibility(
                    visible: _clearButtonVisibility,
                    child: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: ListTile(
            title: Row(
              children: [
                Text("HTTP Methods",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                DropdownButton<String>(
                  value: _httpMethod,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      if(value == "GET") {
                        _bodyController.clear();
                      }
                      _httpMethod = value!;
                    });
                  },
                  items: HTTP_METHODS.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            subtitle: Visibility(
              visible: _httpMethod != "GET",
              child: Padding(
                padding: const EdgeInsets.only(top: HARMONY_PADDING/2),
                child: TextFormField(
                  controller: _bodyController,
                  minLines: 1,
                  maxLines: 1000,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      // Customize border here
                    ),
                  ),
                ),
              ),
            ),

          )
        ),
        SliverToBoxAdapter(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: HARMONY_PADDING),
              child: Text("Response",
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            subtitle: Container(
              constraints: const BoxConstraints(
                minHeight: 80.0, // Minimum height
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(HARMONY_PADDING),
                child: SelectableText(_response),
              ),
            )
          ),
        ),
      ]
    );
  }

  Widget getFab() {
    return FloatingActionButton(
      child: const Icon(Icons.send),
      onPressed: () async {
        setState(() {
          _response = "";
        });
        var response = await connect(_apiController.value.text,
          method: _httpMethod,
          body: _bodyController.value.text,
        );
        setState(() {
          _response = response?.body ?? "";
        });
      }
    );
  }

  Future<http.Response?> connect(String url, {
    String method= "GET", Map<String, String>? headers, String? body
  }) async {
    Uri uri = Uri.parse(url);
    http.Response? response = null;
    switch(method){
      case "GET":
        response = await http.get(uri, headers: headers);
        break;
      case "POST":
        response = await http.post(uri, headers: headers, body: body);
        break;
      case "PUT":
        response = await http.put(uri, headers: headers, body: body);
        break;
      case "DELETE":
        response = await http.delete(uri, headers: headers, body: body);
        break;
      default:
        return null;
    }
    if (kDebugMode){
      print("response code ${response.statusCode} with method: $method and body: $body");
    }
    // https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
    switch(response.statusCode) {
      // success
      case 200:
      case 201:
      case 202:
        return response;
      // others
      default:
        return response;
    }
  }

}

