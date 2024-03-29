import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/device_job_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/global.dart';
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
  String _deviceJobTitle = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DeviceJobDto? newDeviceJob = new DeviceJobDto(title: '');
  Future<DeviceJobDto>? _futureDeviceJob;

  @override
  void initState() {
    super.initState();
    _viewJobs = JobRequests.getJobsForDevType(Global.deviceType.name);
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
                    _jobBody.clear();
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
      Text('Selected job', style: Gui.textStyleFootnote),
      Divider(color: Colors.grey, height: 2),
      Padding(
          padding: EdgeInsets.all(5),
          child: Text(selectedJob!.name, style: TextStyle(fontSize: 16))),
      Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(selectedJob!.description,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontStyle: FontStyle.italic))),
      SizedBox(height: 30),
    ]);
  }

  Widget _fillDevJobData(BuildContext context) {
    if (jobProperties?.length == 0) {
      return Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Please fill the data', style: Gui.textStyleFootnote),
            Divider(color: Colors.grey),
            new Row(children: [
              new Flexible(
                  child: new TextFormField(
                onSaved: (value) => {_deviceJobTitle = value!},
                textInputAction: TextInputAction.next,
                cursorColor: Colors.grey,
                decoration: Gui.inputDecoration('Device Job Title'),
                validator: Validator.notNullOrEmpty,
              )),
            ]),
            SizedBox(height: 15),
            _buildSubmitDevJobButton(context)
          ]));
    } else {
      return Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Please fill the data', style: Gui.textStyleFootnote),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            Row(children: [
              Flexible(
                  child: new TextFormField(
                onSaved: (value) => {_deviceJobTitle = value!},
                textInputAction: TextInputAction.next,
                cursorColor: Colors.grey,
                decoration: Gui.inputDecoration('Device Job Title'),
                validator: Validator.notNullOrEmpty,
              )),
            ]),
            SizedBox(height: 10),
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
                    SizedBox(height: 10),
                  ]);
                }),
            //_orderDevJobButton(context)
            _buildSubmitDevJobButton(context)
          ]));
    }
  }

  Widget _buildSubmitDevJobButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Click button to submit a job.',
          style: TextStyle(
            color: darkerSteelBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              // Validate will return true if the form is valid
              if (_formKey.currentState!.validate()) {
                // Process data.
                setState(() {
                  _formKey.currentState!.save(); // run TextFormField onSaved
                  if (_jobBody.toString() == "") {
                    _jobBodyValue = 'nan';
                  } else {
                    _jobBodyValue = _jobBody.toString();
                  }
                  newDeviceJob?.title = _deviceJobTitle;
                  newDeviceJob?.body = _jobBodyValue;
                  newDeviceJob?.executionTime = '2021-08-10T21:36:17.9426078';
                  _futureDeviceJob = DeviceJobsRequests.postDeviceJob(
                      /*1,*/ Global.device.id,
                      /*1*,*/ selectedJob!.id ?? 0,
                      newDeviceJob!);
                });
                print('newDeviceJob!.title:');
                print(newDeviceJob!.title);
                print('newDeviceJob!.body:');
                print(newDeviceJob!.body);
                print('newDeviceJob!.executionTime:');
                print(newDeviceJob!.executionTime);
              }
            },
            child: Icon(
              Icons.check,
              size: 25,
            ),
            backgroundColor: peachPuff,
            hoverColor: lightBlueGrey,
            elevation: 5,
            tooltip: 'Submit job',
          ),
        ),
        SizedBox(height: 10),
        _returnRequestMessage(context),
      ],
    );
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
              if (_jobBody.toString() == "") {
                _jobBodyValue = 'nan';
              } else {
                _jobBodyValue = _jobBody.toString();
              }
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
        child: const Text(
          'Submit',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
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
                      '${Global.device.id}' +
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
