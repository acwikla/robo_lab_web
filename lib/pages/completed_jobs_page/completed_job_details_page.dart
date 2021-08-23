import 'package:flutter/material.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CompletedJobsDetailedPage extends StatefulWidget {
  const CompletedJobsDetailedPage({Key? key}) : super(key: key);

  @override
  _CompletedJobsDetailedPageState createState() =>
      _CompletedJobsDetailedPageState();
}

class _CompletedJobsDetailedPageState extends State<CompletedJobsDetailedPage> {
  late TooltipBehavior _tooltipBehavior;
  List<ViewDeviceValueDto> _deviceJobValue = [
    new ViewDeviceValueDto(
        id: 1,
        value: '0.6779988',
        dateTime: DateTime.parse('2021-08-10T21:36:17.9426078'),
        propertyId: 1,
        deviceJobId: 1,
        propertyName: 'propertyName1'),
    new ViewDeviceValueDto(
        id: 2,
        value: '0.6888788',
        dateTime: DateTime.parse('2021-08-10T21:37:18.9426078'),
        propertyId: 1,
        deviceJobId: 1,
        propertyName: 'propertyName'),
    new ViewDeviceValueDto(
        id: 3,
        value: '0.79888788',
        dateTime: DateTime.parse('2021-08-10T21:38:19.9426078'),
        propertyId: 1,
        deviceJobId: 1,
        propertyName: 'propertyName')
  ];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'Results of the completed job: ${Global.deviceJob.id}'),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        LineSeries<ViewDeviceValueDto, double>(
            name: _deviceJobValue[0].propertyName,
            dataSource: _deviceJobValue,
            xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                deviceValueDto.dateTime.second.toDouble(),
            yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                double.parse(deviceValueDto.value),
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true)
      ],
      primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        //edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value}',
        //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
      ),
    );
  }
}
