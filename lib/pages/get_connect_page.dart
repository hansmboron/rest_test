import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart' as connect;
import '../widgets/display_value_widget.dart';
import '../widgets/examples_widget.dart';

class GetConnectPage extends StatefulWidget {
  const GetConnectPage({super.key});

  @override
  State<GetConnectPage> createState() => _GetConnectPageState();
}

class _GetConnectPageState extends State<GetConnectPage> {
  connect.Response? response;
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
        title: const Text('get(GetConnect) package'),
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
          DisplayValueWidget(title: 'request', text: response?.request == null ? null : '${response?.request?.method} ${response?.request?.url}'),
          DisplayValueWidget(title: 'statusCode', text: response?.statusCode.toString()),
          DisplayValueWidget(title: 'hasError', text: response?.hasError.toString()),
          DisplayValueWidget(title: 'statusText', text: response?.statusText),
          DisplayValueWidget(title: 'followRedirects', text: response?.request?.followRedirects.toString()),
          DisplayValueWidget(title: 'maxRedirects', text: response?.request?.maxRedirects.toString()),
          DisplayValueWidget(title: 'persistentConnection', text: response?.request?.persistentConnection.toString()),
          DisplayValueWidget(title: 'request headers', text: response?.request?.headers.toString()),
          DisplayValueWidget(title: 'headers', text: response?.headers.toString()),
          DisplayValueWidget(title: 'body', text: response?.body.toString()),
          DisplayValueWidget(title: 'bodyString', text: response?.bodyString),
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
    final client = connect.GetConnect();
    setState(() => isLoading = true);

    try {
      response = await client.get(_urlEC.text);
    } on Exception catch (e) {
      error = e.toString();
    } finally {
      client.dispose();
    }

    setState(() => isLoading = false);
  }
}
