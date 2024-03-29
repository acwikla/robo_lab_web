import 'package:flutter/material.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/gui.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
import 'package:robo_lab_web/routing/routes.dart';

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
      title: Text(devJob.title, style: TextStyle(fontSize: 20)),
      subtitle: _getSubtitleText(devJob),
      leading: _getIcon(devJob),
      onTap: () {
        setState(() {
          //if (devJob.done) {
          navigationController.navigateTo(completedJobDetailsPageRoute,
              arguments: devJob);
          //}
        });
        //Navigator.pushReplacementNamed(context, routes.deviceDetails);
      },
    );
  }

  Text _getSubtitleText(ViewDeviceJobDto devJob) {
    var style = TextStyle(fontSize: 16);
    //if (devJob.done == true) style = TextStyle(fontSize: 16, color: peachPuff);

    return Text(
        'Job name: ' +
            devJob.job.name +
            ', id: ' +
            devJob.id.toString() +
            ', done: ' +
            devJob.done.toString(),
        style: style);
  }

  Widget _getIcon(ViewDeviceJobDto devJob) {
    return Icon(
      Icons.circle,
      color: peachPuff,
    );
  }
}
