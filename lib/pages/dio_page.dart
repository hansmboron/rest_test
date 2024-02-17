import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import '../widgets/display_value_widget.dart';
import '../widgets/examples_widget.dart';

class DioPage extends StatefulWidget {
  const DioPage({super.key});

  @override
  State<DioPage> createState() => _DioPageState();
}

class _DioPageState extends State<DioPage> {
  dio.Response? response;
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
        title: const Text('dio package'),
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
          DisplayValueWidget(title: 'request', text: response?.requestOptions == null ? null : '${response?.requestOptions.method} ${response?.requestOptions.path}'),
          DisplayValueWidget(title: 'request header', text: response?.requestOptions.headers.toString()),
          DisplayValueWidget(title: 'request extra', text: response?.requestOptions.extra.toString()),
          DisplayValueWidget(title: 'statusCode', text: response?.statusCode.toString()),
          DisplayValueWidget(title: 'statusMessage', text: response?.statusMessage),
          DisplayValueWidget(title: 'extra', text: response?.extra.toString()),
          DisplayValueWidget(title: 'extisRedirectra', text: response?.isRedirect.toString()),
          DisplayValueWidget(title: 'redirects', text: response?.redirects.toString()),
          DisplayValueWidget(title: 'persistentConnection', text: response?.requestOptions.persistentConnection.toString()),
          DisplayValueWidget(title: 'responseType', text: response?.requestOptions.responseType.name),
          DisplayValueWidget(title: 'queryParameters', text: response?.requestOptions.queryParameters.toString()),
          DisplayValueWidget(title: 'headers', text: response?.headers.map.toString()),
          DisplayValueWidget(title: 'data', text: response?.data.toString()),
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
    final client = dio.Dio(dio.BaseOptions(
      validateStatus: (status) {
        return true;
      },
    ));
    setState(() => isLoading = true);

    try {
      response = await client.get(_urlEC.text);
    } on Exception catch (e) {
      error = e.toString();
    } finally {
      client.close();
    }

    setState(() => isLoading = false);
  }
}
