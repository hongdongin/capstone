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
        title: const Text('모임 생성'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: '모임 이름'),
                validator: (value) => value!.isEmpty ? '모임 이름을 작성해 주세요.' : null,
                onSaved: (value) => _meetingTitle = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '모임을 소개해 주세요.'),
                validator: (value) => value!.isEmpty ? '소개 내용을 작성해 주세요.' : null,
                onSaved: (value) => _meetingDescription = value!,
              ),
              TextButton(
                child: const Text('모임 생성'),
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
