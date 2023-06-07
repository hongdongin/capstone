import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class MessageButton extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  late String _message;
  final String _table;

  MessageButton(this._table, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('메시지 보내기'),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('보내기'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      // Send the message to Firebase
                      FirebaseFirestore.instance.collection(_table).add({
                        'text': _message,
                        'timestamp': DateTime.now(),
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: '메시지'),
                      validator: (value) =>
                          value!.isEmpty ? '메시지를 작성해 주세요.' : null,
                      onSaved: (value) => _message = value!,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
