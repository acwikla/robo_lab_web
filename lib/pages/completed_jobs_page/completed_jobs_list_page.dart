import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/gui.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';

class CompletedJobsListPage extends StatefulWidget {
  @override
  createState() => _CompletedJobsListPageState();
}

class _CompletedJobsListPageState extends State<CompletedJobsListPage> {
  late Future<List<ViewDeviceJobDto>> _devJobs;

  @override
  void initState() {
    super.initState();
    _devJobs = DeviceJobsRequests.getDeviceJobsForDevice(Global.device.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 3,
        child: ListView(padding: new EdgeInsets.all(10.0), children: [
          Text('Select device job', style: Gui.textStylePageTitle),
          SizedBox(height: 30),
          _buildListView(context)
        ]));
  }

  Widget _buildListView(BuildContext context) {
    return FutureBuilder<List<ViewDeviceJobDto>>(
      future: _devJobs,
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

  ListTile _buildItemsForListView(ViewDeviceJobDto devJob) {
    return ListTile(
      title: Text(devJob.job.name, style: TextStyle(fontSize: 20)),
      subtitle: Text(
          'Id: ' + devJob.id.toString() + ', done: ' + devJob.done.toString(),
          style: TextStyle(fontSize: 16)),
      leading: _getIcon(devJob),
      onTap: () {
        setState(() {
          //Global.device = dev;
          //Global.deviceType = dev.deviceType;
        });
        //Navigator.pushReplacementNamed(context, routes.deviceDetails);
      },
    );
  }

  Widget _getIcon(ViewDeviceJobDto devJob) {
    return Icon(Icons.circle);
  }
}
