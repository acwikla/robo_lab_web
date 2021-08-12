import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/requests/device_requests.dart';

class ExampleTablePage extends StatefulWidget {
  @override
  createState() => _ExampleTablePageState();
}

class _ExampleTablePageState extends State<ExampleTablePage> {
  late Future<List<ViewDeviceDto>> _devices;

  @override
  void initState() {
    super.initState();
    _devices = DeviceRequests.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable(context);
  }

  Widget _buildTable(BuildContext context) {
    return FutureBuilder<List<ViewDeviceDto>>(
      future: _devices,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        } else {
          return DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label:
                    Text('Id', style: TextStyle(fontStyle: FontStyle.italic)),
              ),
              DataColumn(
                label:
                    Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
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
                    return Colors.grey.withOpacity(0.3);
                  }
                  return null; // Use default value for other states and odd rows.
                }),
                cells: <DataCell>[
                  DataCell(Text(snapshot.data![index].id.toString())),
                  DataCell(Text(snapshot.data![index].name.toString()))
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // ListTile _buildItemsForListView(ViewDeviceDto dev) {
  //   //return Text(dev.name);
  //   return ListTile(
  //     title: Text(dev.name, style: TextStyle(fontSize: 20)),
  //     subtitle:
  //         Text('Type: ' + dev.deviceType.name, style: TextStyle(fontSize: 16)),
  //     leading: getIcon(dev.deviceType),
  //     // onTap: () {
  //     //   //Navigator.pushReplacementNamed(context, routes.deviceDetails);
  //     //   Navigator.pushReplacementNamed(context, routes.deviceDetails,
  //     //       arguments: dev);
  //     // },
  //   );
  // }

  // Widget getIcon(DeviceTypeDTO devType) {
  //   if (devType.name == 'SmartTerra')
  //     return Icon(Icons.panorama_horizontal, color: Colors.green);
  //   else if (devType.name == 'RoboArm(Arexx RA-1-PRO)')
  //     return Icon(Icons.auto_awesome_mosaic, color: Colors.blue);
  //   else
  //     return Icon(Icons.question_answer);
  // }
}
