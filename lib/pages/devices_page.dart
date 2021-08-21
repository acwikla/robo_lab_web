import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/device_type_dto.dart';
import 'package:robo_lab_web/dto/view_device_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/requests/device_requests.dart';

import '../gui.dart';

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
    return Container(
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Select active device', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          _buildListView(context)
        ]));
  }

  Widget _buildListView(BuildContext context) {
    return FutureBuilder<List<ViewDeviceDto>>(
      future: _devices,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              shrinkWrap: true,
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
    return ListTile(
      title: Text(dev.name, style: TextStyle(fontSize: 20)),
      subtitle:
          Text('Type: ' + dev.deviceType.name, style: TextStyle(fontSize: 16)),
      leading: _getIcon(dev.deviceType),
      tileColor: dev.id == Global.device?.id ? Colors.grey[300] : Colors.white,
      onTap: () {
        setState(() {
          Global.device = dev;
          Global.deviceType = dev.deviceType;
        });
        //Navigator.pushReplacementNamed(context, routes.deviceDetails);
      },
    );
  }

  Widget _getIcon(DeviceTypeDTO devType) {
    switch (devType.name) {
      case 'SmartTerra':
        return Icon(Icons.yard_outlined, color: Colors.green);
      case 'RoboArm(Arexx RA-1-PRO)':
      case 'Dobot Magician V2':
        return Icon(Icons.precision_manufacturing_outlined, color: Colors.blue);
      case 'Rihanna':
        return Icon(Icons.device_thermostat, color: Colors.orange);
      default:
        return Icon(Icons.device_unknown);
    }
  }
}
