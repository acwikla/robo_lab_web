import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/requests/device_requests.dart';

class DevicesPage extends StatefulWidget {
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late Future<List<ViewDeviceDto>> _devices;

  @override
  void initState() {
    super.initState();
    _devices = DeviceRequests.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView(context);
  }

  Widget _buildListView(BuildContext context) {
    return FutureBuilder<List<ViewDeviceDto>>(
      future: _devices,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  //child: Text(snapshot.data![index].name),
                  child: _buildItemsForListView(snapshot.data![index]),
                );
              });
        }
      },
    );
  }

  ListTile _buildItemsForListView(ViewDeviceDto dev) {
    //return Text(dev.name);
    return ListTile(
      title: Text(dev.name, style: TextStyle(fontSize: 20)),
      subtitle:
          Text('Type: ' + dev.deviceType.name, style: TextStyle(fontSize: 16)),
      leading: getIcon(dev.deviceType),
      // onTap: () {
      //   //Navigator.pushReplacementNamed(context, routes.deviceDetails);
      //   Navigator.pushReplacementNamed(context, routes.deviceDetails,
      //       arguments: dev);
      // },
    );
  }

  Widget getIcon(DeviceTypeDTO devType) {
    if (devType.name == 'SmartTerra')
      return Icon(Icons.panorama_horizontal, color: Colors.green);
    else if (devType.name == 'RoboArm(Arexx RA-1-PRO)')
      return Icon(Icons.auto_awesome_mosaic, color: Colors.blue);
    else
      return Icon(Icons.question_answer);
  }
}
