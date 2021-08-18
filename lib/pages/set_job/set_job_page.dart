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

class _SetJobPageState extends State<SetJobPage> {
  late Future<List<JobDto>> _viewJobs;
  JobDto? selectedJob = JobDto(
      id: 0, name: '0', description: '0', properties: '0', deviceTypeName: '0');

  @override
  void initState() {
    super.initState();
    _viewJobs = JobRequests.getJobsForDevType(GlobalData.globalDeviceType.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(children: [
      SizedBox(
        height: 50,
      ),
      //_buildTable(context)
      _buildDropDownList(context)
    ]));
  }

  Widget _buildDropDownList(BuildContext context) {
    return FutureBuilder<List<JobDto>>(
        future: _viewJobs,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator(color: skyBlue));
          } else {
            return DropdownButton<JobDto>(
              hint: Text("Select job"),
              value: snapshot.data![0],
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
              onChanged: (newValue) {
                setState(() {
                  selectedJob = newValue;
                });
              },
            );
          }
        });
  }

  Widget _buildTable(BuildContext context) {
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
  }
}
