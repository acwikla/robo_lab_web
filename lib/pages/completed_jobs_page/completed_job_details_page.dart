import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robo_lab_web/constants/style_const.dart';
import 'package:robo_lab_web/dto/view_device_job_dto.dart';
import 'package:robo_lab_web/dto/view_device_value_dto.dart';
import 'package:robo_lab_web/global.dart';
import 'package:robo_lab_web/gui.dart';
import 'package:robo_lab_web/requests/device_jobs_requests.dart';
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
  //late List<ViewDeviceValueDto> _deviceJobValue;
  late Future<List<ViewDeviceValueDto>> _deviceJobValues;

  @override
  void initState() {
    _deviceJobValues =
        DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 5,
      color: lightBlueGrey,
      elevation: 10,
      shadowColor: topPanelColor,
      //tooltipPosition: TooltipPosition.pointer
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildJobPropertiesTable(context)),
        Expanded(flex: 3, child: _buildJobValueChart(context))
      ],
    );
  }

  Widget _buildJobPropertiesTable(BuildContext context) {
    return Container(child: Text('tu bedzie tabelka'));
  }

  Widget _buildJobValueChart(BuildContext context) {
    return FutureBuilder<List<ViewDeviceValueDto>>(
        future: _deviceJobValues,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator(color: skyBlue));
          } else {
            return SfCartesianChart(
                title: ChartTitle(
                  text: 'Results of the completed job: ${Global.deviceJob.id}',
                  alignment: ChartAlignment.far, //?
                  textStyle: TextStyle(
                      color: darkerSteelBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                margin: EdgeInsets.fromLTRB(5, 40, 10, 40),
                //palette
                plotAreaBackgroundColor: superLightBlueGrey,
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    alignment: ChartAlignment.center,
                    //borderColor: lighterPeachPuff,
                    //borderWidth: 2,
                    //offset: Offset(40, 40),
                    //overflowMode: LegendItemOverflowMode.wrap,
                    title: LegendTitle(
                        text: 'Data',
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ))),
                tooltipBehavior: _tooltipBehavior,
                plotAreaBorderColor: Colors.transparent,
                series: <ChartSeries>[
                  LineSeries<ViewDeviceValueDto, DateTime>(
                      width: 2,
                      name: snapshot.data?[0].propertyName,
                      color: leftMenuColor,
                      dataSource: snapshot.data ?? [],
                      xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                          deviceValueDto.dateTime,
                      yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                          double.parse(deviceValueDto.value),
                      dataLabelSettings: DataLabelSettings(
                          textStyle: TextStyle(
                              fontFamily: GoogleFonts.ptSansTextTheme
                                  .toString(), //'Roboto',
                              fontSize: 14,
                              color: Colors.blueGrey[800]),
                          isVisible: true),
                      enableTooltip: true),
                ],
                primaryXAxis: DateTimeAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  dateFormat: DateFormat.Hms(),
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 13),
                  //rangePadding: ,
                  axisLine: AxisLine(color: lightBlueGrey),
                  title: AxisTitle(
                      text: 'Time',
                      textStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(color: lightBlueGrey),
                    //decimalPlaces: 4,
                    labelFormat: '{value}',
                    labelStyle:
                        TextStyle(color: Colors.black87, fontSize: 13)));
          }
        });
  }
}
