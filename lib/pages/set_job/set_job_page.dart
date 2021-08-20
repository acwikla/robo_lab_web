import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/device_job_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/global_data.dart';
import 'package:robo_lab_web/gui.dart';
import 'package:robo_lab_web/patterns/custom_summary_cadr.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:robo_lab_web/requests/job_requests.dart';
import 'package:robo_lab_web/utils/job_body.dart';
import 'package:robo_lab_web/utils/property.dart';
import 'package:robo_lab_web/validator.dart';

class SetJobPage extends StatefulWidget {
  @override
  createState() => _SetJobPageState();
}

class _SetJobPageState extends State<SetJobPage> {
  late Future<List<JobDto>> _viewJobs;
  JobDto? selectedJob;

  List<JobProperty>? jobProperties = [];
  var _jobBody = new JobBody();
  String _jobBodyValue = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //TextEditingController? _controller; // = TextEditingController();

  DeviceJobDto? newDeviceJob = new DeviceJobDto();
  Future<DeviceJobDto>? _futureDeviceJob;

  @override
  void initState() {
    super.initState();
    _viewJobs = JobRequests.getJobsForDevType(GlobalData.globalDeviceType.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Submit a job for your device', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          _buildSelectJobList(context),
          SizedBox(height: 30),
          _viewDevJobData(context)
        ]));
  }

  Widget _buildSelectJobList(BuildContext context) {
    return FutureBuilder<List<JobDto>>(
        future: _viewJobs,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator(color: skyBlue));
          } else {
            return DropdownButton<JobDto>(
                style: TextStyle(fontSize: 17),
                hint: Text("Select job"),
                value: selectedJob,
                onChanged: (newValue) {
                  setState(() {
                    selectedJob = newValue;
                  });
                },
                items: snapshot.data!.map((job) {
                  return DropdownMenuItem(
                      value: job,
                      child: Row(children: <Widget>[
                        SizedBox(width: 10),
                        Text(job.name, style: TextStyle(color: Colors.black)),
                      ]));
                }).toList());
          }
        });
  }

  Widget _viewDevJobData(BuildContext context) {
    if (selectedJob == null) {
      return CustomSummaryCard(subtitleText: 'No job has been selected');
    } else {
      jobProperties = JobProperty.splitString(selectedJob!.properties);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _showSelectedJob(context),
            _fillDevJobData(context),
          ]);
    }
  }

  Widget _showSelectedJob(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Selected job', style: Gui.textStyleParagraph),
      Divider(color: Colors.grey, height: 2),
      Padding(
          padding: EdgeInsets.all(5),
          child: Text(selectedJob!.name, style: TextStyle(fontSize: 16))),
      Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(selectedJob!.description,
              style: TextStyle(color: Colors.black54, fontSize: 14))),
      SizedBox(height: 30),
    ]);
  }

  Widget _fillDevJobData(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Please fill the data', style: Gui.textStyleParagraph),
          Divider(color: Colors.grey),
          ListView.builder(
              shrinkWrap: true,
              itemCount: jobProperties?.length ?? 0,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  new Row(children: [
                    new Flexible(
                        child: new TextFormField(
                      onSaved: (value) =>
                          {_jobBody.set(jobProperties![index].name!, value)},
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.grey,
                      decoration:
                          Gui.inputDecoration(jobProperties![index].name),
                      validator: Validator.notNullOrEmpty,
                    )),
                  ]),
                  SizedBox(height: 15),
                ]);
              }),
          SizedBox(height: 15),
          _orderDevJobButton(context)
        ]));
  }

  Widget _orderDevJobButton(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ElevatedButton(
        style: Gui.buttonStyleSubmit,
        onPressed: () {
          // Validate will return true if the form is valid
          if (_formKey.currentState!.validate()) {
            // Process data.
            setState(() {
              _formKey.currentState!.save(); // run TextFormField onSaved
              _jobBodyValue = _jobBody.toString();
              newDeviceJob?.body = _jobBodyValue;
              newDeviceJob?.executionTime = '2021-08-10T21:36:17.9426078';
              _futureDeviceJob = DeviceJobsRequests.postDeviceJob(
                  1, //GlobalData.globalDevice.id,
                  1, //selectedJob!.id,
                  newDeviceJob!);
            });
            print(newDeviceJob!.body);
            print(newDeviceJob!.executionTime);
          }
        },
        child: const Text('Submit'),
      ),
      SizedBox(height: 15),
      _returnRequestMessage(context),
    ]);
  }

  Widget _returnRequestMessage(BuildContext context) {
    return FutureBuilder<DeviceJobDto>(
      future: _futureDeviceJob,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomSummaryCard(
              subtitleText:
                  'Job has been successfully submitted for a device with ID: ' +
                      '${GlobalData.globalDevice.id}' +
                      ', with job body: ' +
                      '${snapshot.data!.body}.');
        } else if (snapshot.hasError) {
          return CustomSummaryCard(subtitleText: '${snapshot.error}');
        }
        return //const CircularProgressIndicator();
            CustomSummaryCard(subtitleText: 'No action was taken.');
      },
    );
  }
}
