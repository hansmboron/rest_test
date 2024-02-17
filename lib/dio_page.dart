import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dio package'),
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Exemplos:'),
            TextButton(
              onPressed: () {
                _urlEC.text = 'https://viacep.com.br/ws/01001000/json/';
              },
              child: const Text('https://viacep.com.br/ws/01001000/json/'),
            ),
            TextButton(
              onPressed: () {
                _urlEC.text = 'https://jsonplaceholder.typicode.com/todos/';
              },
              child: const Text('https://jsonplaceholder.typicode.com/todos/'),
            ),
            TextButton(
              onPressed: () {
                _urlEC.text = 'http://127.0.0.1:8080';
              },
              child: const Text('http://127.0.0.1:8080'),
            ),
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
            SelectableText.rich(
              TextSpan(text: 'request: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.method} ${response?.requestOptions.path}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'request header: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.headers}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'request extra: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.extra}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'statusCode: ', children: [
                TextSpan(
                  text: '${response?.statusCode}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'statusMessage: ', children: [
                TextSpan(
                  text: '${response?.statusMessage}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'extra: ', children: [
                TextSpan(
                  text: '${response?.extra}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'isRedirect: ', children: [
                TextSpan(
                  text: '${response?.isRedirect}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'redirects: ', children: [
                TextSpan(
                  text: '${response?.redirects}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'persistentConnection: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.persistentConnection}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'responseType: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.responseType.name}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'queryParameters: ', children: [
                TextSpan(
                  text: '${response?.requestOptions.queryParameters}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'headers: ', children: [
                TextSpan(
                  text: '${response?.headers}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'data: ', children: [
                TextSpan(
                  text: '${response?.data}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: error != null,
              child: SelectableText.rich(
                TextSpan(text: 'Error: ', children: [
                  TextSpan(
                    text: '$error',
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.red.shade800),
                  ),
                ]),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800),
              ),
            ),
          ],
        ),
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
