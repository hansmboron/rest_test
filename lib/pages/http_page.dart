import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/display_value_widget.dart';
import '../widgets/examples_widget.dart';

class HttpPage extends StatefulWidget {
  const HttpPage({super.key});

  @override
  State<HttpPage> createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  http.Response? response;
  String? error;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _urlEC = TextEditingController();

  @override
  void dispose() {
    _urlEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('http package'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExamplesWidget(editingController: _urlEC),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Type/Paste URL',
                    suffix: SizedBox(
                      height: 24,
                      child: TextButton(
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          _urlEC.text = '';
                          setState(() {
                            response = null;
                            error = null;
                          });
                        },
                        child: const Text('clear', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                  controller: _urlEC,
                  validator: (value) {
                    if (value == null || value.isEmpty || !(value.contains('http://') || value.contains('https://'))) {
                      return 'Invalid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      final bool valid = _formKey.currentState?.validate() ?? false;
                      if (valid) {
                        await _sendRequest();
                      }
                    },
                    child: const Text('Send Request'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Visibility(
            visible: isLoading,
            replacement: const SizedBox(height: 4),
            child: const LinearProgressIndicator(),
          ),
          const SizedBox(height: 12),
          DisplayValueWidget(title: 'request', text: response?.request.toString()),
          DisplayValueWidget(title: 'statusCode', text: response?.statusCode.toString()),
          DisplayValueWidget(title: 'reasonPhrase', text: response?.reasonPhrase),
          DisplayValueWidget(title: 'contentLength', text: response?.contentLength == null ? null : '${response?.contentLength} bytes'),
          DisplayValueWidget(title: 'persistentConnection', text: response?.persistentConnection.toString()),
          DisplayValueWidget(title: 'headers', text: response?.headers.toString()),
          DisplayValueWidget(title: 'body', text: response?.body),
          Visibility(
            visible: error != null,
            child: DisplayValueWidget(title: 'Error', text: error, isError: true),
          ),
        ],
      ),
    );
  }

  Future<void> _sendRequest() async {
    error = null;
    response = null;
    final client = http.Client();
    setState(() => isLoading = true);

    try {
      final Uri url = Uri.parse(_urlEC.text);
      response = await client.get(url);
    } on Exception catch (e) {
      error = e.toString();
    } finally {
      client.close();
    }

    setState(() => isLoading = false);
  }
}
