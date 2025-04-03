import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/postWriterForm.dart';

class NewClubPostPage extends StatelessWidget {
  final int clubId;

  const NewClubPostPage({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const HeaderPage(pageTitle: '동아리 피드 작성'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PostWriterForm(
            clubId: clubId,
            onPostUploaded: () {
              Navigator.pop(context, true);
            },
          ),
        ),
      ),
    );
  }
}