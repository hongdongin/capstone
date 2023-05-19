import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMeetingPage extends ConsumerStatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  CreateMeetingPageState createState() => CreateMeetingPageState();
}

class CreateMeetingPageState extends ConsumerState<CreateMeetingPage> {
  final _formKey = GlobalKey<FormState>();
  late String _meetingTitle;
  late String _meetingDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Meeting'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Meeting Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a meeting title' : null,
                onSaved: (value) => _meetingTitle = value!,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Meeting Description'),
                validator: (value) => value!.isEmpty
                    ? 'Please enter a meeting description'
                    : null,
                onSaved: (value) => _meetingDescription = value!,
              ),
              TextButton(
                child: const Text('Create Meeting'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create the meeting in Firebase
                    FirebaseFirestore.instance.collection('meetings').add({
                      'title': _meetingTitle,
                      'description': _meetingDescription,
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
