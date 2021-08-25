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
  late Future<List<ViewDeviceValueDto>> _futureDeviceJobValues;
  late List<ViewDeviceValueDto> _deviceJobValues = [];
  List<String> deviceValueAllPropertyNames = []; //out
  late List<String> jobPropertyName = [];
  String _selectedProperty = 'Data';
  List<ViewDeviceValueDto> _propertyValue = [];

  @override
  void initState() {
    _futureDeviceJobValues =
        DeviceJobsRequests.getDeviceJobValues(Global.deviceJob.id);
    //convert Future<List<T> -> List<T>,
    //_deviceJobValues = await _futureDeviceJobValues;- nope
    _futureDeviceJobValues.then((value) {
      setState(() => value.forEach((item) => _deviceJobValues.add(item)));
    });

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
        Expanded(flex: 1, child: _buildJobPropertiesTable(context)),
        Expanded(flex: 3, child: _buildJobValueChart(context))
      ],
    );
  }

  Widget _buildJobPropertiesTable(BuildContext context) {
    String val = '';
    _deviceJobValues.forEach(
        (f) => {val = f.propertyName, print("_deviceJobValues: $val.")});
    _deviceJobValues
        .forEach((f) => deviceValueAllPropertyNames.add(f.propertyName));
    jobPropertyName =
        new Set<String>.from(deviceValueAllPropertyNames).toList();
    jobPropertyName.forEach((f) => print("result: $f"));
    _deviceJobValues
        .where((element) => element.propertyName == _selectedProperty)
        .forEach((element) {
      _propertyValue.add(element);
    });

    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(5, 40, 10, 40),
        child: ListView(
          children: [
            Text(
              'Select chart data',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                color: darkerSteelBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (int i = 0; i <= jobPropertyName.length - 1; i++)
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                title:
                    Text('${jobPropertyName[i]}', style: Gui.textStyleCasual),
                selected: false,
                leading: Radio(
                  value: jobPropertyName[i],
                  groupValue: _selectedProperty,
                  activeColor: peachPuff, //lightBlueGrey,
                  focusColor: Colors.grey,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedProperty = value!;
                      print('new');
                      print(_selectedProperty);
                      _propertyValue.clear();
                    });
                  },
                ),
              ),
            /*
          RadioListTile<String>(
                title:
                    Text('${jobPropertyName[i]}', style: Gui.textStyleCasual),
                value: jobPropertyName[i],
                activeColor: peachPuff,
                groupValue: _selectedProperty,
                onChanged: (String? value) {
                  setState(() {
                    _selectedProperty = value!;
                    print('new');
                    print(_selectedProperty);
                    _propertyValue.clear();
                  });
                },
              ),
        */
          ],
        ));
  }

  Widget _buildJobValueChart(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(
          text: 'Results of the completed job: ${Global.deviceJob.id}',
          alignment: ChartAlignment.far, //?
          textStyle: TextStyle(
            color: darkerSteelBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
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
              name: _selectedProperty,
              color: leftMenuColor,
              dataSource: _propertyValue,
              xValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  deviceValueDto.dateTime,
              yValueMapper: (ViewDeviceValueDto deviceValueDto, _) =>
                  double.parse(deviceValueDto.value),
              dataLabelSettings: DataLabelSettings(
                  textStyle: TextStyle(
                      fontFamily:
                          GoogleFonts.ptSansTextTheme.toString(), //'Roboto',
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
            labelStyle: TextStyle(color: Colors.black87, fontSize: 13)));

    /*return FutureBuilder<List<ViewDeviceValueDto>>(
        future: _futureDeviceJobValues,
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
                    fontWeight: FontWeight.bold,
                  ),
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
        });*/
  }
}
