import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:robo_lab_web/constants/controllers_instance.dart';
import 'package:robo_lab_web/controllers/job_controller.dart';
import 'package:robo_lab_web/helpers/responsivness.dart';
import 'package:robo_lab_web/patterns/custom_text.dart';

class SetJobPage extends StatefulWidget {
  const SetJobPage({Key? key}) : super(key: key);

  @override
  _SetJobPage createState() => _SetJobPage();
}

//zeby byla mozliwosc nawigacji pomiedzy kartami obowiazkowo Obx??
class _SetJobPage extends State<SetJobPage> {
  @override
  void initState() {
    super.initState();
    fetchJobsForDevType('SmartTerra');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Description',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Properties',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(JobController.fetchedJob.name)),
                    DataCell(Text(JobController.fetchedJob.description)),
                    DataCell(Text(JobController.fetchedJob.properties)),
                  ],
                ),
                /*DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text('bu'),
                    ),
                    DataCell(Text('25')),
                    DataCell(Text('Software Developer')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('bu')),
                    DataCell(Text('29')),
                    DataCell(Text('Team Lead ')),
                  ],
                ),*/
              ],
            )
          ],
        ))
      ],
    );
  }
}
