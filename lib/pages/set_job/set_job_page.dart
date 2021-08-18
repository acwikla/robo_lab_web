import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/job_dto.dart';
import 'package:robo_lab_web/global_data.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';
import 'package:robo_lab_web/requests/job_requests.dart';

class SetJobPage extends StatefulWidget {
  @override
  createState() => _SetJobPageState();
}

class JobProperty {
  JobProperty({
    this.name,
    this.type,
    this.min,
    this.max,
  });

  String? name;
  String? type;
  int? min;
  int? max;

  static void mapString(String properties) {
    if (properties != '') {
      JobProperty jobProperty;
      JobProperty jobProperty2;
      int commaIndex;
      for (int i = 0; i < properties.length; i++) {
        //jobProperty2 = new JobProperty(name: 'bu');
        //_SetJobPageState.jobsProperties.add(jobProperty2);
        if (properties.substring(i, i + 5) == 'name') {
          i += 5;
          for (int j = i; i < properties.length; j++) {
            if (properties[j] == ',') {
              commaIndex = j;
              jobProperty = new JobProperty(name: properties.substring(i, j));
              _SetJobPageState.jobsProperties.add(jobProperty);
              return;
            }
          }
        }
      }
    }
  }
}

class _SetJobPageState extends State<SetJobPage> {
  late Future<List<JobDto>> _viewJobs;
  JobDto? selectedJob;
  static late List<JobProperty> jobsProperties = [
    new JobProperty(name: 'propName1', type: 'string'),
    new JobProperty(name: 'propName2', type: 'string')
  ];

  @override
  void initState() {
    super.initState();
    _viewJobs = JobRequests.getJobsForDevType(GlobalData.globalDeviceType.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(padding: new EdgeInsets.all(7.0), children: [
      Text('Submit a job for your device',
          style: TextStyle(
              color: darkerSteelBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      SizedBox(height: 30),
      //_buildTable(context)
      _buildDropDownList(context),
      SizedBox(height: 30),
      _fillInData(context)
    ]));
  }

  Widget _fillInData(BuildContext context) {
    if (selectedJob == null) {
      return Card(
          child: ListTile(
              leading: Icon(Icons.ballot_outlined, size: 25), //(size: 56.0),
              title: Text('Summary', style: TextStyle(fontSize: 17)),
              subtitle: Text('No job has been selected',
                  style:
                      TextStyle(fontStyle: FontStyle.italic, fontSize: 16))));
    } else {
      //JobProperty.mapString(selectedJob!.properties);
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_showSelectedJob(context), _fillData(context)]);
    }
  }

  Widget _showSelectedJob(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Selected job',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w600)),
      Divider(color: Colors.grey),
      Padding(
        padding: EdgeInsets.all(5),
        child: Text(selectedJob!.name, style: TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
        child: Text(selectedJob!.description,
            style: TextStyle(color: Colors.black54, fontSize: 14)),
      ),
      SizedBox(height: 30)
    ]);
  }

  Widget _fillData(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Please fill the data',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w600)),
      Divider(color: Colors.grey),
      ListView.builder(
          shrinkWrap: true,
          itemCount: jobsProperties.length ?? 0,
          itemBuilder: (BuildContext context, index) {
            return Column(
              children: [
                new Row(
                  children: [
                    new Flexible(
                      child: new TextField(
                        cursorColor: Colors.grey,
                        decoration: new InputDecoration(
                            fillColor: Colors.black26,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            labelText: jobsProperties[index].name,
                            labelStyle: TextStyle(color: Colors.black38)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15)
              ],
            );
          })
    ]);
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
