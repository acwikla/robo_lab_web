import 'package:flutter/material.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/pages/completed_jobs_page/completed_job_details_page.dart';

class DiagramsPage extends StatefulWidget {
  const DiagramsPage({Key? key}) : super(key: key);

  @override
  _DiagramsPageState createState() => _DiagramsPageState();
}

class _DiagramsPageState extends State<DiagramsPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CompletedJobDetailsPage(deviceJob: Global.deviceJob))
      ],
    );
  }
}
