import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/gui.dart';
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
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        duration: 5,
        color: topPanelColor,
        elevation: 10,
        shadowColor: topPanelColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(
          text: 'Results of the completed job: ${Global.deviceJob.id}',
          alignment: ChartAlignment.near, //?
          textStyle: Gui.textStylePageTitle,
        ),
        margin: EdgeInsets.all(40),
        //palette
        //zoomPanBehavior
        //enableMultiSelection
        plotAreaBackgroundColor: backgroundChartColor, //lighterPeachPuff,
        legend: Legend(
            isVisible: true,
            //borderColor: lightBlueGrey,
            //borderWidth: 1,
            //position: LegendPosition.bottom,
            //offset: Offset(40, 40),
            //overflowMode: LegendItemOverflowMode.wrap,
            //isResponsive: true,
            title: LegendTitle(
                text: 'Data',
                textStyle: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 15,
                ))),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          LineSeries<ViewDeviceValueDto, DateTime>(
              name: _deviceJobValue[0].propertyName,
              color: darkSteelBlue,
              dataSource: _deviceJobValue,
              xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  deviceValueDto.dateTime,
              yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  double.parse(deviceValueDto.value),
              dataLabelSettings: DataLabelSettings(
                  textStyle: TextStyle(
                      fontFamily:
                          GoogleFonts.ptSansTextTheme.toString(), //'Roboto',
                      fontSize: 12,
                      color: Colors.blueGrey[800]),
                  isVisible: true),
              enableTooltip: true)
        ],
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat.Hms(),
          //rangePadding: ,
          title: AxisTitle(
              text: 'Time',
              textStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              )),
        ),
        primaryYAxis: NumericAxis(
          //decimalPlaces: 4,
          labelFormat: '{value}',
        ));
  }
}
