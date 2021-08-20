import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/device_job_dto.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/global_data.dart';
import 'package:robo_lab_web/patterns/custom_summary_cadr.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:robo_lab_web/requests/job_requests.dart';
import 'package:robo_lab_web/utils/job_body.dart';
import 'package:robo_lab_web/utils/property.dart';

class SetJobPage extends StatefulWidget {
  @override
  createState() => _SetJobPageState();
}

class _SetJobPageState extends State<SetJobPage> {
  late Future<List<JobDto>> _viewJobs;
  JobDto? selectedJob;

  List<JobProperty>? jobProperties = [];
  List<JobBody>? jobBody = [];
  String _jobBodyValue = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _controller; // = TextEditingController();

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
          Text('Submit a job for your device',
              style: TextStyle(
                  color: darkerSteelBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          //_buildTable(context)
          _buildDropDownList(context),
          SizedBox(height: 30),
          viewDevJobData(context)
        ]));
  }

  Widget viewDevJobData(BuildContext context) {
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
      Text('Selected job',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w600)),
      Divider(color: Colors.grey, height: 2),
      Padding(
        padding: EdgeInsets.all(5),
        child: Text(selectedJob!.name, style: TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
        child: Text(selectedJob!.description,
            style: TextStyle(color: Colors.black54, fontSize: 14)),
      ),
      SizedBox(height: 30),
    ]);
  }

  Widget _fillDevJobData(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Please fill the data',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          Divider(color: Colors.grey),
          ListView.builder(
              shrinkWrap: true,
              itemCount: jobProperties?.length ?? 0,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    new Row(
                      children: [
                        new Flexible(
                          child: new TextFormField(
                              //keyboardType: TextInputType.number,
                              controller: _controller,
                              onFieldSubmitted: (text) {
                                if (jobBody?[index].value != null) {
                                  print('on change: ' + text);
                                  jobBody?.add(new JobBody(
                                      name: jobProperties![index].name,
                                      value: text //_jobBodyValue
                                      ));
                                } else {
                                  print('on else: ' + text);
                                  jobBody?[index].value = text;
                                }
                                print(
                                    'index: $index, name: ${jobBody![index].name}, val: ${jobBody![index].value}');
                              },
                              /*jobBody?.add(new JobBody(
                                    name: jobProperties![index].name,
                                    value: _jobBodyValue //_jobBodyValue
                                    ));
                                print(
                                    'index: $index, name: ${jobBody![index].name}, val: ${jobBody![index].value}'); */

                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.grey,
                              decoration: new InputDecoration(
                                fillColor: Colors.black26,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                labelText: jobProperties![index].name,
                                labelStyle: TextStyle(color: Colors.black38),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some data';
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                );
              }),
          SizedBox(height: 15),
          _orderDevJobButton(context)
        ]));
  }

  Widget _orderDevJobButton(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(darkSteelBlue),
            overlayColor: MaterialStateProperty.all(lightSteelBlue)),
        onPressed: () {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState!.validate()) {
            // Process data.
            setState(() {
              _jobBodyValue = JobBody.changeListToString(jobBody!);
              //_controller?.text ?? ''; //_jobBodyValue;
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

  Widget _buildDropDownList(BuildContext context) {
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
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        job.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  /*Widget _buildTable(BuildContext context) {
    return FutureBuilder<List<JobDto>>(
      future: _viewJobs,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator(color: skyBlue));
        } else {
          return DataTable(
            decoration: BoxDecoration(),
            dataRowHeight: 50,
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Name',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              DataColumn(
                label: Text('Description',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              DataColumn(
                label: Text('Properties',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
            rows: List<DataRow>.generate(
              snapshot.data?.length ?? 0,
              (int index) => DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  // All rows will have the same selected color.
                  // Even rows will have a grey color.
                  if (index.isEven) {
                    return darkerPeachPuff.withOpacity(0.3);
                  }
                  return null; // Use default value for other states and odd rows.
                }),
                cells: <DataCell>[
                  DataCell(Text(snapshot.data![index].name.toString())),
                  DataCell(Text(snapshot.data![index].description.toString())),
                  DataCell(Text(snapshot.data![index].properties.toString())),
                ],
              ),
            ),
          );
        }
      },
    );
  }*/
}
