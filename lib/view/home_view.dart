import 'package:ask_pdf/view/notifiers/index_notifier.dart';
import 'package:ask_pdf/view/notifiers/query_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _formKey = GlobalKey<FormState>();

class HomeView extends HookConsumerWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryState = ref.watch(queryNotifierProvider);
    final queryTextCtrl = useTextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ask Pdf',
            style: TextStyle(
              color: Color(0xFF0047FF),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chat with any PDF document From legal agreements to financial reports, PDF.ai brings your documents to life. You can ask questions, get summaries, find information, and more.',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        backgroundColor: Color(Colors.orangeAccent.value),
                      ),
                      onPressed: () {
                        ref
                            .read(indexNotifierProvider.notifier)
                            .createAndUploadPineConeIndex();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Upload PDF',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: queryTextCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter a query',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0047FF),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          ref
                              .read(queryNotifierProvider.notifier)
                              .queryPineConeIndex(queryTextCtrl.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text('Ask'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    if (queryState.state == QueryEnum.loading)
                      const LinearProgressIndicator(),
                    if (queryState.state == QueryEnum.loaded)
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFFD1A300),
                                width: 2,
                              ),
                              color: Color.fromARGB(104, 242, 190, 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pdf Ai Answering...",
                                    style: TextStyle(
                                        color: Color(0xFFD1A300),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(queryState.result),
                                ],
                              ),
                            )),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
